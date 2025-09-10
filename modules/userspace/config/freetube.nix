{ config, ... }:

{
  programs.freetube.settings = {
    bounds = {
      x = 0;
      y = 0;
      width = config.nixtra.screen.width / 2;
      height = config.nixtra.screen.height / 1.13924050633;
    };
    autoplayPlaylists = false;
    checkForBlogPosts = false;
    checkForUpdates = false;
    downloadBehavior = "download";
    enableScreenshot = false;
    enableSearchSuggestions = false;
    hideChannelSorts = true;
    hidePopularVideos = true;
    hideSubscriptionsShorts = true;
    hideTrendingVideos = true;
    rememberHistory = false;
    rememberSearchHistory = false;
    saveWatchedProgress = false;
    useSponsorBlock = true;
  };
}
