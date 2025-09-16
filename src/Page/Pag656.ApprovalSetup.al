#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 656 "Approval Setup"
{
    Caption = 'Approval Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable452;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Due Date Formula";"Due Date Formula")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Administrator";"Approval Administrator")
                {
                    ApplicationArea = Basic;
                }
                field("Request Rejection Comment";"Request Rejection Comment")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Notification)
            {
                Caption = 'Notification';
                group("Notify User about:")
                {
                    Caption = 'Notify User about:';
                    field(Approvals;Approvals)
                    {
                        ApplicationArea = Basic;
                    }
                    field(Cancellations;Cancellations)
                    {
                        ApplicationArea = Basic;
                    }
                    field(Rejections;Rejections)
                    {
                        ApplicationArea = Basic;
                    }
                    field(Delegations;Delegations)
                    {
                        ApplicationArea = Basic;
                    }
                }
                group("Overdue Approvals")
                {
                    Caption = 'Overdue Approvals';
                    field("Last Run Date";"Last Run Date")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
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
        area(navigation)
        {
            group("&Mail Templates")
            {
                Caption = '&Mail Templates';
                Image = Template;
                group("Approval Mail Template")
                {
                    Caption = 'Approval Mail Template';
                    Image = Template;
                    action(Import)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import';
                        Ellipsis = true;
                        Image = Import;

                        trigger OnAction()
                        begin
                            CalcFields("Approval Template");
                            if "Approval Template".Hasvalue then
                              AppTemplateExists := true;

                            if FileMgt.BLOBImport(TempBlob,'*.HTM') = '' then
                              exit;

                            "Approval Template" := TempBlob.Blob;

                            if AppTemplateExists then
                              if not Confirm(Text002,false,FieldCaption("Approval Template")) then
                                exit;

                            CurrPage.SaveRecord;
                        end;
                    }
                    action("E&xport")
                    {
                        ApplicationArea = Basic;
                        Caption = 'E&xport';
                        Ellipsis = true;
                        Image = Export;

                        trigger OnAction()
                        begin
                            CalcFields("Approval Template");
                            if "Approval Template".Hasvalue then begin
                              TempBlob.Blob := "Approval Template";
                              FileMgt.BLOBExport(TempBlob,'*.HTM',true);
                            end;
                        end;
                    }
                    action(Delete)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Delete';
                        Ellipsis = true;
                        Image = Delete;

                        trigger OnAction()
                        begin
                            CalcFields("Approval Template");
                            if "Approval Template".Hasvalue then
                              if Confirm(Text003,false,FieldCaption("Approval Template")) then begin
                                Clear("Approval Template");
                                CurrPage.SaveRecord;
                              end;
                        end;
                    }
                }
                group("Overdue Mail Template")
                {
                    Caption = 'Overdue Mail Template';
                    Image = Overdue;
                    action(Action27)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import';
                        Ellipsis = true;
                        Image = Import;

                        trigger OnAction()
                        begin
                            CalcFields("Overdue Template");
                            OverdueTemplateExists := "Overdue Template".Hasvalue;

                            if FileMgt.BLOBImport(TempBlob,'*.HTM') = '' then
                              exit;

                            "Overdue Template" := TempBlob.Blob;

                            if OverdueTemplateExists then
                              if not Confirm(Text002,false,FieldCaption("Overdue Template")) then
                                exit;

                            CurrPage.SaveRecord;
                        end;
                    }
                    action(Action28)
                    {
                        ApplicationArea = Basic;
                        Caption = 'E&xport';
                        Ellipsis = true;
                        Image = Export;

                        trigger OnAction()
                        begin
                            CalcFields("Overdue Template");
                            if "Overdue Template".Hasvalue then begin
                              TempBlob.Blob := "Overdue Template";
                              FileMgt.BLOBExport(TempBlob,'*.HTM',true);
                            end;
                        end;
                    }
                    action(Action29)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Delete';
                        Ellipsis = true;
                        Image = Delete;

                        trigger OnAction()
                        begin
                            CalcFields("Overdue Template");
                            if "Overdue Template".Hasvalue then
                              if Confirm(Text003,false,FieldCaption("Overdue Template")) then begin
                                Clear("Overdue Template");
                                CurrPage.SaveRecord;
                              end;
                        end;
                    }
                }
            }
            group("&Overdue")
            {
                Caption = '&Overdue';
                Image = Overdue;
                action("Send Overdue Mails")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Overdue Mails';
                    Image = OverdueMail;

                    trigger OnAction()
                    begin
                        if Confirm(StrSubstNo(Text004,Today),true) then begin
                          ApprMgtNotification.LaunchCheck(Today);
                          "Last Run Date" := Today;
                          "Last Run Time" := Time;
                          Modify;
                          CurrPage.Update;
                        end;
                    end;
                }
                action("Overdue Log Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Overdue Log Entries';
                    Image = OverdueEntries;
                    RunObject = Page "Overdue Approval Entries";
                }
            }
        }
        area(processing)
        {
            action("&User Setup")
            {
                ApplicationArea = Basic;
                Caption = '&User Setup';
                Image = UserSetup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Approval User Setup";
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;

    var
        TempBlob: Record TempBlob;
        ApprMgtNotification: Codeunit "IC Setup Diagnostics";
        FileMgt: Codeunit "File Management";
        OverdueTemplateExists: Boolean;
        Text002: label 'Do you want to replace the existing %1?';
        Text003: label 'Do you want to delete the template %1?';
        AppTemplateExists: Boolean;
        Text004: label 'Do you want to run the overdue check by the %1?';
}

