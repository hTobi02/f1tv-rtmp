import logging
import re
import uuid

from streamlink.cache import Cache
from streamlink.plugin import Plugin, PluginArgument, PluginArguments, pluginmatcher
from streamlink.plugin.api import validate
from streamlink.stream import DASHStream, HLSStream
from streamlink.utils import parse_json
from streamlink.utils.args import comma_list_filter

log = logging.getLogger(__name__)


@pluginmatcher(re.compile(
    r"https?://((www|live|f1tv)\.)?formula1\.com/"
))
class F1TV(Plugin):
    STREAMS_ZATTOO = ['dash', 'hls7']

    TIME_CONTROL = 60 * 60 * 2
    TIME_SESSION = 60 * 60 * 24 * 30
    _player_re = re.compile(r'''bitmovinplayer-video-main-embeddedPlayer\s*=\s*"(?P<jsondata>.*?)"''')
    _player_url_schema = validate.Schema(
        validate.transform(_player_re.search),
        validate.any(None, validate.all(
            validate.get("jsondata"),
            validate.text,
            validate.transform(lambda v: parse_json(v.replace("'", '"'))),
            validate.transform(lambda v: verifyjson(v, "url")),
        ))
    )
    arguments = PluginArguments(
        PluginArgument(
            "email",
            requires=["password"],
            metavar="EMAIL",
            help="""
            The email associated with your f1tv account,
            required to access any f1tv stream.
            """),
        PluginArgument(
            "password",
            sensitive=True,
            metavar="PASSWORD",
            help="""
            A f1tv account password to use with --f1tv-email.
            """)
    )
    def _get_streams(self):
        res = self.session.http.get(self.url)
        data_url = self._player_url_schema.validate(res.text)
        if not data_url:
            log.error("Could not find video at this url.")
            return

        data_url = urljoin(res.url, data_url)
        log.debug(f"Player URL: '{data_url}'")
        res = self.session.http.get(data_url)
        mediainfo = parse_json(res.text, name="MEDIAINFO", schema=self._mediainfo_schema)
        log.trace("Mediainfo: {0!r}".format(mediainfo))

        for media in mediainfo["_mediaArray"]:
            for stream in media["_mediaStreamArray"]:
                stream_ = stream["_stream"]
                if isinstance(stream_, list):
                    if not stream_:
                        continue
                    stream_ = stream_[0]

                if ".m3u8" in stream_:
                    yield from HLSStream.parse_variant_playlist(self.session, stream_).items()
                elif ".mp4" in stream_ and ".f4m" not in stream_:
                    yield "{0}".format(self._QUALITY_MAP[stream["_quality"]]), HTTPStream(self.session, stream_)
                else:
                    if ".f4m" not in stream_:
                        log.error("Unexpected stream type: '{0}'".format(stream_))
"""
    def __init__(self, url):
        super().__init__(url)
        self.domain = self.match.group('base_url')
        self._session_attributes = Cache(
            filename='plugin-cache.json',
            key_prefix='zattoo:attributes:{0}'.format(self.domain))
        self._uuid = self._session_attributes.get('uuid')
        self._authed = (self._session_attributes.get('power_guide_hash')
                        and self._uuid
                        and self.session.http.cookies.get('pzuid', domain=self.domain)
                        and self.session.http.cookies.get('beaker.session.id', domain=self.domain)
                        )
        self._session_control = self._session_attributes.get('session_control',
                                                             False)
        self.base_url = 'https://{0}'.format(self.domain)
        self.headers = {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'X-Requested-With': 'XMLHttpRequest',
            'Referer': self.base_url
        }

    def _login(self, email, password):
        log.debug('_login ...')
        data = self.session.http.post(
            f'https://account.formula1.com/#/gsw/login',
            headers=self.headers,
            data={
                'login': email,
                'password': password,
                'format': 'json',
            },
            acceptable_status=(200, 400),
            schema=validate.Schema(validate.transform(parse_json), validate.any(
                {'active': bool, 'power_guide_hash': str},
                {'success': bool},
            )),
        )

        if data.get('active'):
            log.debug('Login was successful.')
        else:
            log.debug('Login failed.')
            return

        self._authed = data['active']
        self.save_cookies(default_expires=self.TIME_SESSION)
        self._session_attributes.set('power_guide_hash',
                                     data['power_guide_hash'],
                                     expires=self.TIME_SESSION)
        self._session_attributes.set(
            'session_control', True, expires=self.TIME_CONTROL)

    def reset_session(self):
        self._session_attributes.set('power_guide_hash', None, expires=0)
        self._session_attributes.set('uuid', None, expires=0)
        self.clear_cookies()
        self._authed = False

    def _get_streams(self):
        email = self.get_option('email')
        password = self.get_option('password')

        if not self._authed and (not email and not password):
            log.error(
                'A login for Zattoo is required, use --zattoo-email EMAIL'
                ' --zattoo-password PASSWORD to set them')
            return

        if not self._authed:
            self._login(email, password)

        if self._authed:
            return self._watch()

"""

__plugin__ = F1TV
