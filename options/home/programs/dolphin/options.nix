{
  lib,
  config,
  pkgs,
  ...
}: let
  mkSubModuleOptions = moduleOptions:
    lib.mkOption {
      type = lib.types.submodule {options = moduleOptions;};
      default = {};
    };
in {
  options.programs.dolphin = mkSubModuleOptions {
    enable = lib.mkEnableOption "dolphin";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kdePackages.dolphin;
    };

    services-menu = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf (lib.types.attrsOf lib.types.str));
      default = {};
    };

    settings = {
      General = {
        Version = lib.mkOption {
          type = lib.types.number;
          default = 202;
        };
        ViewPropsTimestamp = lib.mkOption {
          type = lib.types.str;
          default = "2026,9,4,15,19,31.34";
        };
        DoubleClickViewAction = lib.mkOption {
          type = lib.types.str;
          default = "edit_select_all";
        };
        DoubleClickViewCustomAction = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
        EditableUrl = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        UrlCompletionMode = lib.mkOption {
          type = lib.types.int;
          default = 0;
        };
        ShowFullPath = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        ShowFullPathInTitlebar = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        OpenExternallyCalledFolderInNewTab = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        AlwaysShowTabBar = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        ShowCloseButtonOnTabs = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        TabStyle = lib.mkOption {
          type = lib.types.enum ["AutoSize" "FullWidth" "FixedSize"];
          default = "AutoSize";
        };
        HomeUrl = lib.mkOption {
          type = lib.types.str;
          default = config.home.homeDirectory;
        };
        RememberOpenedTabs = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        SplitView = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        FilterBar = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        GlobalViewProps = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        BrowseThroughArchives = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        ConfirmClosingMultipleTabs = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ConfirmClosingTerminalRunningProgram = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        RenameInline = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowSelectionToggle = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowPasteBarAfterCopying = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        UseTabForSwitchingSplitView = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        CloseSplitViewChoice = lib.mkOption {
          type = lib.types.enum ["ActiveView" "InactiveView" "RightView"];
          default = "ActiveView";
        };
        OpenNewTabAfterLastTab = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        ShowToolTips = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        AutoExpandFolders = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        ShowStatusBar = lib.mkOption {
          type = lib.types.enum ["Small" "FullWidth" "Disabled"];
          default = "Small";
        };
        ShowZoomSlider = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        LockPanels = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        EnlargeSmallPreviews = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        SortingChoice = lib.mkOption {
          type = lib.types.enum ["NaturalSorting" "CaseInsensitiveSorting" "CaseSensitiveSorting"];
          default = "NaturalSorting";
        };
        HideXTrashFile = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        DynamicView = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        ModifiedStartupSettings = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      "KFileDialog Settings" = {
        "Places Icons Auto-resize" = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        "Places Icons Static Size" = lib.mkOption {
          type = lib.types.number;
          default = 22;
        };
      };

      MainWindow = {
        "MenuBar" = lib.mkOption {
          type = lib.types.enum ["Disabled" "Enabled"];
          default = "Disabled";
        };
      };

      CompactMode = {
        UseSystemFont = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ViewFont = lib.mkOption {
          type = lib.types.str;
          default = "System Font";
        };
        IconSize = lib.mkOption {
          type = lib.types.int;
          default = 22;
        };
        PreviewSize = lib.mkOption {
          type = lib.types.int;
          default = 48;
        };
        MaximumTextWidthIndex = lib.mkOption {
          type = lib.types.int;
          default = 0;
        };
      };

      ContentDisplay = {
        DirectorySizeMode = lib.mkOption {
          type = lib.types.enum ["ContentCount" "ContentSize" "None"];
          default = "ContentCount";
        };
        RecursiveDirectorySizeLimit = lib.mkOption {
          type = lib.types.int;
          default = 10;
        };
        UseShortRelativeDates = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        UsePermissionsFormat = lib.mkOption {
          type = lib.types.enum ["SymbolicFormat" "NumericFormat" "CombinedFormat"];
          default = "SymbolicFormat";
        };
        ElidingMode = lib.mkOption {
          type = lib.types.enum ["Right" "Middle"];
          default = "Middle";
        };
      };

      ContextMenu = {
        ShowCopyMoveMenu = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        ShowAddToPlaces = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowSortBy = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowViewMode = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowOpenInNewTab = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowOpenInNewWindow = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowOpenInSplitView = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowCopyLocation = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowDuplicateHere = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowOpenTerminal = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowCopyToOtherSplitView = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ShowMoveToOtherSplitView = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };

      DetailsMode = {
        UseSystemFont = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ViewFont = lib.mkOption {
          type = lib.types.str;
          default = "System Font";
        };
        IconSize = lib.mkOption {
          type = lib.types.int;
          default = 16;
        };
        PreviewSize = lib.mkOption {
          type = lib.types.int;
          default = 48;
        };
        ColumnPositions = lib.mkOption {
          type = lib.types.str;
          default = "0,1,2,3,4,5,6,7,8";
        };
        LeftPadding = lib.mkOption {
          type = lib.types.int;
          default = 20;
        };
        RightPadding = lib.mkOption {
          type = lib.types.int;
          default = 20;
        };
        HighlightEntireRow = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ExpandableFolders = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };

      IconsMode = {
        UseSystemFont = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ViewFont = lib.mkOption {
          type = lib.types.str;
          default = "System Font";
        };
        IconSize = lib.mkOption {
          type = lib.types.int;
          default = 32;
        };
        PreviewSize = lib.mkOption {
          type = lib.types.int;
          default = 64;
        };
        TextWidthIndex = lib.mkOption {
          type = lib.types.int;
          default = 1;
        };
        MaximumTextLines = lib.mkOption {
          type = lib.types.int;
          default = 3;
        };
      };

      Settings = {
        HiddenFilesShown = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      Dolphin = {
        Version = lib.mkOption {
          type = lib.types.int;
          default = -1;
        };
        ViewMode = lib.mkOption {
          type = lib.types.int;
          default = 0;
        };
        PreviewsShown = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        GroupedSorting = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        SortRole = lib.mkOption {
          type = lib.types.str;
          default = "text";
        };
        SortOrder = lib.mkOption {
          type = lib.types.int;
          default = 0;
        };
        SortFoldersFirst = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        SortHiddenLast = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        VisibleRoles = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
        };
        HeaderColumnWidths = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
      };

      NotificationMessages = {
        ConfirmOpenManyFolders = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ConfirmOpenManyTerminals = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        ConfirmRenameFileType = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };

      PreviewSettings = {
        Plugins = lib.mkOption {
          type = lib.types.str;
          default = "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,ffmpegthumbs";
        };
      };

      VersionControl = {
        enabledPlugins = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
        };
      };
    };
  };
}
