#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9171 "Profile List"
{
    ApplicationArea = Basic;
    Caption = 'Profile List';
    CardPageID = "Profile Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Resource Translation';
    SourceTable = "Profile";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Profile ID";"Profile ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Profile ID';
                    ToolTip = 'Specifies the ID (name) of the profile.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description of the profile.';
                }
                field("Role Center ID";"Role Center ID")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Caption = 'Role Center ID';
                    Lookup = false;
                    ToolTip = 'Specifies the ID of the Role Center associated with the profile.';
                }
                field("Default Role Center";"Default Role Center")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Default Role Center';
                    ToolTip = 'Specifies whether the Role Center associated with this profile is the default Role Center.';
                }
                field("Disable Personalization";"Disable Personalization")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether personalization is disabled for users of the profile.';
                }
                field("Use Record Notes";"Use Record Notes")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies information used by the OneNote integration feature. For more information, see How to: Set up OneNote Integration for a Group of Users.';
                }
                field("Record Notebook";"Record Notebook")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies information used by the OneNote integration feature. For more information, see How to: Set up OneNote Integration for a Group of Users.';
                }
                field("Use Page Notes";"Use Page Notes")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies information used by the OneNote integration feature. For more information, see How to: Set up OneNote Integration for a Group of Users.';
                }
                field("Page Notebook";"Page Notebook")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies information used by the OneNote integration feature. For more information, see How to: Set up OneNote Integration for a Group of Users.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(SetDefaultRoleCenter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Set Default Role Center';
                    Image = Default;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Specify that this Role Center will open by default when the user starts the client.';

                    trigger OnAction()
                    var
                        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
                    begin
                        TestField("Profile ID");
                        TestField("Role Center ID");
                        Validate("Default Role Center",true);
                        Modify;
                        ConfPersonalizationMgt.ChangeDefaultRoleCenter("Profile ID");
                    end;
                }
                action("Copy Profile")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Copy Profile';
                    Ellipsis = true;
                    Image = Copy;
                    Promoted = true;
                    ToolTip = 'Copy an existing profile to create a new profile based on the same content.';

                    trigger OnAction()
                    var
                        "Profile": Record "Profile";
                        CopyProfile: Report "Copy Profile";
                    begin
                        Profile.SetRange("Profile ID","Profile ID");
                        CopyProfile.SetTableview(Profile);
                        CopyProfile.RunModal;

                        if Get(CopyProfile.GetProfileID) then;
                    end;
                }
                action("Import Profile")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Import Profile';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    ToolTip = 'Implement UI configurations for a profile by importing an XML file that holds the configured profile.';

                    trigger OnAction()
                    begin
                        Commit;
                        Report.RunModal(Report::"Import Profiles",false);
                        Commit;
                    end;
                }
                action(ExportProfiles)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Export Profiles';
                    Image = Export;
                    Promoted = true;
                    ToolTip = 'Export a profile, for example to reuse UI configurations in other Dynamics NAV databases.';

                    trigger OnAction()
                    var
                        "Profile": Record "Profile";
                        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
                    begin
                        CurrPage.SetSelectionFilter(Profile);
                        ConfPersonalizationMgt.ExportProfilesInZipFile(Profile);
                    end;
                }
            }
            group("Resource Translation")
            {
                Caption = 'Resource Translation';
                action("Import Translated Profile Resources From Folder")
                {
                    ApplicationArea = All;
                    Caption = 'Import Translated Profile Resources From Folder';
                    Ellipsis = true;
                    Image = Language;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Import the translated profile data into the profile from a folder.';
                    Visible = CanRunDotNetOnClient;

                    trigger OnAction()
                    var
                        ProfileRec: Record "Profile";
                        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
                    begin
                        CurrPage.SetSelectionFilter(ProfileRec);
                        ConfPersonalizationMgt.ImportTranslatedResourcesWithFolderSelection(ProfileRec);
                    end;
                }
                action("Import Translated Profile Resources From Zip File")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Import Translated Profile Resources From Zip File';
                    Ellipsis = true;
                    Image = Language;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Import the translated profile data into the profile from a Zip file.';

                    trigger OnAction()
                    var
                        ProfileRec: Record "Profile";
                        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
                    begin
                        CurrPage.SetSelectionFilter(ProfileRec);
                        ConfPersonalizationMgt.ImportTranslatedResources(ProfileRec,'',true);
                    end;
                }
                action("Export Translated Profile Resources")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Export Translated Profile Resources';
                    Ellipsis = true;
                    Image = ExportAttachment;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Prepare to perform customized translation of profiles by exporting and importing resource (.resx) files.';

                    trigger OnAction()
                    var
                        ProfileRec: Record "Profile";
                        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
                    begin
                        CurrPage.SetSelectionFilter(ProfileRec);
                        ConfPersonalizationMgt.ExportTranslatedResourcesWithFolderSelection(ProfileRec);
                    end;
                }
                action("Remove Translated Profile Resources")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Remove Translated Profile Resources';
                    Ellipsis = true;
                    Image = RemoveLine;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Remove the translated resource from the profile.';

                    trigger OnAction()
                    var
                        ProfileRec: Record "Profile";
                        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
                    begin
                        CurrPage.SetSelectionFilter(ProfileRec);
                        ConfPersonalizationMgt.RemoveTranslatedResourcesWithLanguageSelection(ProfileRec);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        FileManagement: Codeunit "File Management";
    begin
        CanRunDotNetOnClient := FileManagement.CanRunDotNetOnClient
    end;

    var
        CanRunDotNetOnClient: Boolean;
}

