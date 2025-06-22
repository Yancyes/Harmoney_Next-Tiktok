interface Base {
  width: number;
  height: number;
}

interface ResourceBase extends Base {
  uri: string;
  url_list: string[];
}

interface PlayableResourceBase extends ResourceBase {
  url_key: string;
  data_size?: number;
  file_hash?: string;
  file_cs?: string;
}

interface MusicCover extends ResourceBase {}

interface VideoCover extends ResourceBase {}

interface MusicPlayUrl extends PlayableResourceBase {}

interface VideoPlayAddr extends PlayableResourceBase {
  data_size: number; // 覆盖为必选字段
  file_hash: string;
  file_cs: string;
}

interface Music {
  id: number;
  title: string;
  author: string;
  cover_medium: MusicCover;
  cover_thumb: MusicCover;
  play_url: MusicPlayUrl;
  duration: number;
  user_count: number;
  owner_id: string;
  owner_nickname: string;
  is_original: boolean;
}

interface Video extends Base {
  play_addr: VideoPlayAddr;
  cover: VideoCover;
  poster: string;
  ratio: string;
  use_static_cover: boolean;
  duration: number;
}

interface ShareInfo {
  share_url: string;
  share_link_desc: string;
}

interface TextExtra {
  start: number;
  end: number;
  type: number;
  hashtag_name: string;
  hashtag_id: string;
  is_commerce: boolean;
  caption_start: number;
  caption_end: number;
}

interface Statistics {
  admire_count: number;
  comment_count: number;
  digg_count: number;
  collect_count: number;
  play_count: number;
  share_count: number;
}

interface Status {
  listen_video_status: number;
  is_delete: boolean;
  allow_share: boolean;
  is_prohibited: boolean;
  in_reviewing: boolean;
  part_see: number;
  private_status: number;
  review_result: { review_status: number };
}

interface RiskInfos {
  vote: boolean;
  warn: boolean;
  risk_sink: boolean;
  type: number;
  content: string;
}

interface SuggestWord {
  word: string;
  word_id: string;
  info: string;
}

interface SuggestWords {
  words: SuggestWord[];
  scene: string;
  icon_url: string;
  hint_text: string;
  extra_info: string;
}

interface AwemeControl {
  can_forward: boolean;
  can_share: boolean;
  can_comment: boolean;
  can_show_comment: boolean;
}

export interface mediaType {
  aweme_id: string;
  desc: string;
  create_time: number;
  music: Music;
  video: Video;
  share_url: string;
  statistics: Statistics;
  status: Status;
  text_extra: TextExtra[];
  is_top: number;
  share_info: ShareInfo;
  duration: number;
  image_infos: any | null;
  risk_infos: RiskInfos;
  position: any | null;
  author_user_id: number;
  prevent_download: boolean;
  long_video: any | null;
  aweme_control: AwemeControl;
  images: any | null;
  suggest_words: SuggestWords[];
}