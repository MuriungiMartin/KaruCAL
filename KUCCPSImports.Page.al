#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68491 "KUCCPS Imports"
{
    PageType = List;
    SourceTable = UnknownTable70082;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Selected;Selected)
                {
                    ApplicationArea = Basic;
                }
                field(ser;ser)
                {
                    ApplicationArea = Basic;
                }
                field(Index;Index)
                {
                    ApplicationArea = Basic;
                }
                field(Admin;Admin)
                {
                    ApplicationArea = Basic;
                }
                field(Prog;Prog)
                {
                    ApplicationArea = Basic;
                }
                field(Names;Names)
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field(Phone;Phone)
                {
                    ApplicationArea = Basic;
                }
                field("Alt. Phone";"Alt. Phone")
                {
                    ApplicationArea = Basic;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field(Box;Box)
                {
                    ApplicationArea = Basic;
                }
                field(Codes;Codes)
                {
                    ApplicationArea = Basic;
                }
                field(Town;Town)
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field("Slt Mail";"Slt Mail")
                {
                    ApplicationArea = Basic;
                }
                field(Processed;Processed)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Email Notification Send";"Email Notification Send")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(OTP;OTP)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Documents Count";"Documents Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Assigned Room";"Assigned Room")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Assigned Space";"Assigned Space")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Assigned Block";"Assigned Block")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Funding %";"Funding %")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Billable_Amount;Billable_Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Receipt Amount";"Receipt Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Funding Category";"Funding Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Current Approval Level";"Current Approval Level")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action(Process)
                {
                    ApplicationArea = Basic;
                    Caption = '&Process Admissions';
                    Image = ExecuteBatch;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ACAAdmImportedJABBuffer: Record UnknownRecord70082;
                    begin
                        if Confirm('Process Selected Student?',true)=false then  Error('Cancelled!');
                        // REPORT.RUN(51348,TRUE,TRUE);
                        //  END ELSE BEGIN
                            ACAAdmImportedJABBuffer.Reset;
                            ACAAdmImportedJABBuffer.SetRange(Selected,true);
                            ACAAdmImportedJABBuffer.SetRange(Processed,false);
                            if ACAAdmImportedJABBuffer.Find('-') then begin
                              Report.Run(51348,false,false,ACAAdmImportedJABBuffer);
                              end;
                            CurrPage.Update;
                    end;
                }
                action(Import)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import';
                    Image = Import;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm('Import KUCCPS Students',true)=false then exit;
                        if Confirm('Arrange your CSV in the forllowing order:\'+
                        'ser'+
                        '\Index'+
                        '\Admin'+
                        '\Prog'+
                        '\Names'+
                        '\Gender'+
                        '\Phone'+
                        '\Alt. Phone'+
                        '\Box'+
                        '\Codes'+
                        '\Town'+
                        '\Email'+
                        '\Slt Mail') = false then;
                        Xmlport.Run(50187,false,true);
                    end;
                }
                action(SelectAll)
                {
                    ApplicationArea = Basic;
                    Caption = 'Select All';
                    Image = SelectReport;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Clear(KUCCPSImports);
                        if not (Confirm('Select all records?',true)) then Error('Cancelled!');
                        KUCCPSImports.Reset;
                        KUCCPSImports.CopyFilters(Rec);
                        if KUCCPSImports.Find('-') then begin
                          repeat
                            begin
                              KUCCPSImports.Selected:=true;
                              KUCCPSImports.Modify;
                            end;
                            until KUCCPSImports.Next = 0;
                          end;
                    end;
                }
                action(UnselectAll)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unselect All';
                    Image = UndoShipment;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if not (Confirm('Unselect all records?',true)) then Error('Cancelled!');
                        KUCCPSImports.Reset;
                        KUCCPSImports.CopyFilters(Rec);
                        if KUCCPSImports.Find('-') then begin
                          repeat
                            begin
                              KUCCPSImports.Selected:=false;
                              KUCCPSImports.Modify;
                            end;
                            until KUCCPSImports.Next = 0;
                          end;
                    end;
                }
                action(Archive)
                {
                    ApplicationArea = Basic;
                    Caption = 'Archive Selected';
                    Image = Archive;
                    Promoted = true;
                    PromotedIsBig = true;
                }
                action(SendNotifications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Mail Notifications';
                    Image = SendConfirmation;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        SendMailNoticiations: Codeunit "SendMails Easy";
                        KUCCPSImports: Record UnknownRecord70082;
                    begin
                        if Confirm('Send email notification to Prospective Students?',true)= false  then  Error('Mail sending cancelled');
                        Clear(KUCCPSImports);
                        KUCCPSImports.Reset;
                        KUCCPSImports.SetRange(Processed,false);
                        KUCCPSImports.SetRange("Email Notification Send",false);
                        KUCCPSImports.SetFilter(Email,'<>%1','');
                        if KUCCPSImports.Find('-') then begin
                          repeat
                            begin
                            SendMailNoticiations.SendEmailEasy('Dear, ',KUCCPSImports.Names,'We are glad to inform you that you have been offered admission to Karatina University.',
                            'You are therefore advised to start your Admission by filling your details on the Portal at <a href = "https://karu.ac.ke/kuccps-admission-2023-2024-updated/">Self Admission</a> to update your profile '+
                            ' and do self admission','Disclaimer....','Disclaimer.....',
                            KUCCPSImports.Email,'ADMISSION NOTIFICATION');
                            KUCCPSImports."Email Notification Send" := true;
                            KUCCPSImports.Modify;
                            end;
                            until KUCCPSImports.Next = 0;
                          Message('Notifications have been send.');
                          end else Error('Nothing to update ');
                    end;
                }
            }
        }
    }

    var
        JAB: Record UnknownRecord70082;
        Admissions: Record UnknownRecord61372;
        AdminSetup: Record UnknownRecord61371;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AdminCode: Code[20];
        KUCCPSImports: Record UnknownRecord70082;


    procedure SplitNames(var Names: Text[100];var Surname: Text[50];var "Other Names": Text[50])
    var
        lngPos: Integer;
    begin
        /*Get the position of the space character*/
        lngPos:=StrPos(Names,' ');
        if lngPos<>0 then
          begin
            Surname:=CopyStr(Names, 1 , lngPos-1);
            "Other Names":=CopyStr(Names,lngPos +1);
          end;

    end;
}

