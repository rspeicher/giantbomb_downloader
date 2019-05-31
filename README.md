# giantbomb_downloader

Automatically download videos from [GiantBomb] via the [GiantBomb
API](https://www.giantbomb.com/api/).

Intended as a replacement for [FlexGet](https://flexget.com/) and the [buggy
GiantBomb RSS feeds][rss].

## Usage

Clone the project, run `bundle install`, and provide your API key via the
`GIANTBOMB_TOKEN` environment variable, and run `bin/giantbomb_downloader`.

```sh
$ bundle install

$ GIANTBOMB_TOKEN=9a97831eb649a5f9695e235e5093d7e5f45877ee bin/giantbomb_downloader
```

If any videos are downloaded, it will write to `~/.config/giantbomb/state.json`
with the timestamp of the last video downloaded. This will be read on subsequent
runs in order to avoid re-downloading videos.

## Configuration

Configuration is done via the [`config/videos.json`](./config/videos.json) file.
Configure where to save your videos, and any videos you want to reject based on
title matching.

Let's look at the default configuration:

```json
{
  "destination": "/Users/rspeicher/Movies/{{guid}} - {{name}}{{extension}}",
  "reject": {
    "name": [
      "Gaiden the Ring",
      "Giant Bombcast",
      "Monster Hunter",
      "Ranking of Fighters",
      "Breakfast 'N' Ben",
      "PokéMonday"
    ]
  }
}
```

This will download all videos except for `Gaiden the Ring`, `Giant Bombcast`,
`Ranking of Fighters`, etc. to `/Users/rspeicher/Movies`, with a filename
format of `[guid] - [name][extension]`. For example, [this video][video] would
download as `2970-19285 - Quick Look Resident Evil 4 (Nintendo Switch).mp4`.

Any attributes [on the video
resource](https://www.giantbomb.com/api/documentation/#toc-0-48) can be
supplied, but I'd recommend keeping it simple, since this is largely untested.

Check out [GiantBomb.bundle](https://github.com/rspeicher/GiantBomb.bundle) to
auto-match these videos in Plex.

## Requirements

`wget` and Ruby 2.3+ with Bundler. Installation for these requirements is
outside the scope of this document.

## License

See [LICENSE](./LICENSE).

[GiantBomb]: https://www.giantbomb.com/
[rss]: https://www.giantbomb.com/forums/api-developers-3017/rss-feeds-seem-to-show-different-video-ids-than-th-1859037/
[video]: https://www.giantbomb.com/shows/resident-evil-4-nintendo-switch/2970-19285/free-video
