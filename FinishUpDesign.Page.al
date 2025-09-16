#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9623 "Finish Up Design"
{
    Caption = 'Finish Up Design';
    PageType = NavigatePage;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(ChooseSave)
            {
                Caption = 'ChooseSave';
                Visible = ChooseVisible;
                label(ChooseDescription)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Your changes to the pages have been recorded. You can review which changes to keep in the next step.';
                }
                part(DesignListPart;"Finish Design List Part")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Choose how to save changes';
                    Editable = false;
                }
            }
            group("Step 1")
            {
                Caption = 'Step 1';
                Visible = Step1Visible;
                group("Step 1 of 2")
                {
                    Caption = 'Step 1 of 2';
                    group("NEW EXTENSION DEFINITION")
                    {
                        Caption = 'NEW EXTENSION DEFINITION';
                        label(NewExtensionDescription)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Fill in information about the new extension and choose next. The information you provide is visible in the Store.';
                        }
                        group(Control31)
                        {
                            field(Name;ExtName)
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Name';
                                NotBlank = true;
                                ShowMandatory = true;
                                ToolTip = 'Specifies the name of the Extension.';
                            }
                            field(Publisher;ExtPub)
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Publisher';
                                ToolTip = 'Specifies the name of the Extension publisher.';
                            }
                            field(Description;ExtDesc)
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Description';
                                MultiLine = true;
                                ToolTip = 'Specifies the description of the Extension.';
                            }
                        }
                    }
                }
            }
            group("Step 2")
            {
                Caption = 'Step 2';
                Visible = Step2Visible;
                group("Step 2 of 2")
                {
                    Caption = 'Step 2 of 2';
                    group("SUPPORT AND INSTALLATION")
                    {
                        Caption = 'SUPPORT AND INSTALLATION';
                        label(SupportDescription)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'People installing the extension can look up information about it. Provide the links you want to publish with the extension.';
                        }
                        group(Control33)
                        {
                            field(PublisherWebsite;ExtWeb)
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Publisher website (URL)';
                                ToolTip = 'Specifies the website for the Extension publisher.';
                            }
                            field(SupportWebsite;ExtHelp)
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Support website (URL)';
                                ToolTip = 'Specifies a support website for the Extension.';
                            }
                            field(RequireEula;RequireEula)
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Require EULA accept prior to installation';
                                ToolTip = 'Specifies if users are required to accept the Extension''s EULA before installation';
                            }
                        }
                        group(ADVANCED)
                        {
                            Caption = 'ADVANCED';
                            label(AdvancedDescription)
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Review the Extension contents and privileges if you want to update what goes into the Extension manifest.';
                            }
                            field(ReviewContents;ReviewContentsLbl)
                            {
                                ApplicationArea = Basic,Suite;
                                DrillDown = true;
                                Editable = false;
                                ShowCaption = false;

                                trigger OnDrillDown()
                                begin
                                    CurrPage.Close;
                                end;
                            }
                            field(ManagePrivileges;ManagePrivilagesLbl)
                            {
                                ApplicationArea = Basic,Suite;
                                DrillDown = true;
                                Editable = false;
                                ShowCaption = false;

                                trigger OnDrillDown()
                                begin
                                    CurrPage.Close;
                                end;
                            }
                        }
                    }
                }
            }
            group(Success)
            {
                Caption = 'Success';
                Visible = SuccessVisible;
                group(PublishSuccess)
                {
                    Caption = 'Extension published successfully!';
                    label(SuccessDescription)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'The extension is now available for installation from the Extension Management page.';
                    }
                    field(MgmtLink;GoToExtensionMgmtLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = true;
                        Editable = false;
                        ShowCaption = false;

                        trigger OnDrillDown()
                        begin
                            CurrPage.Close;
                            Page.Run(Page::"Extension Management");
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Go)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Go';
                Image = Approve;
                InFooterBar = true;
                Visible = GoVisible;

                trigger OnAction()
                begin
                    GoVisible := false;
                    ChooseVisible := false;

                    NextVisible := true;
                    PreviousVisible := true;
                    Step1Visible := true;
                end;
            }
            action(Previous)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Previous';
                Image = PreviousRecord;
                InFooterBar = true;
                Visible = PreviousVisible;

                trigger OnAction()
                begin
                    if Step1Visible then begin
                      GoVisible := true;
                      ChooseVisible := true;

                      NextVisible := false;
                      PreviousVisible := false;
                      Step1Visible := false;
                    end else
                      if Step2Visible then begin
                        NextVisible := true;
                        Step1Visible := true;

                        PublishVisible := false;
                        Step2Visible := false;
                      end;
                end;
            }
            action(Next)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Image = NextRecord;
                InFooterBar = true;
                Visible = NextVisible;

                trigger OnAction()
                begin
                    NextVisible := false;
                    Step1Visible := false;

                    PublishVisible := true;
                    Step2Visible := true;
                end;
            }
            action(Publish)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Publish';
                Image = Approve;
                InFooterBar = true;
                Visible = PublishVisible;

                trigger OnAction()
                begin
                    PreviousVisible := false;
                    PublishVisible := false;
                    Step2Visible := false;

                    SuccessVisible := true;
                    OkVisible := true;
                end;
            }
            action(Ok)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Ok';
                Image = Approve;
                InFooterBar = true;
                Visible = OkVisible;

                trigger OnAction()
                begin
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        GoVisible := true;
        ChooseVisible := true;
        RequireEula := true;
    end;

    var
        GoVisible: Boolean;
        PreviousVisible: Boolean;
        NextVisible: Boolean;
        PublishVisible: Boolean;
        OkVisible: Boolean;
        ChooseVisible: Boolean;
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        SuccessVisible: Boolean;
        GoToExtensionMgmtLbl: label 'Go To Extension Management';
        RequireEula: Boolean;
        [InDataSet]
        ExtName: Text;
        ExtPub: Text;
        ExtDesc: Text;
        ExtHelp: Text;
        ExtWeb: Text;
        ReviewContentsLbl: label 'Review and update Extension contents';
        ManagePrivilagesLbl: label 'Manage required Extension privileges';
}

