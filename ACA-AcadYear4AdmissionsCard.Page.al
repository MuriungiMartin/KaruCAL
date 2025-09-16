#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77353 "ACA-AcadYear 4 Admissions Card"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = UnknownTable61382;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Send Admission SMS";"Send Admission SMS")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send SMS';
                }
                field("Send Admission Mail";"Send Admission Mail")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Email';
                }
                field("Admissions Message";"Admissions Message")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000005;"KUCCPS Imports")
            {
                Caption = 'Import Detail';
                SubPageLink = "Academic Year"=field(Code);
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Imports)
            {
                ApplicationArea = Basic;
                Caption = 'Import KUCCPS';
                Image = AdjustEntries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm('Import KUCCPS Students',true)=false then exit;
                    if Confirm('Arrange your CSV in the forllowing order:\'+
                    'ser'+
                    '\Academic_Year'+
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
                    '\Slt Mail'+
                    '\Settlement Type'+
                    '\Funding Category') = false then;
                    Xmlport.Run(50187,false,true);
                end;
            }
            action(Process)
            {
                ApplicationArea = Basic;
                Caption = '&Process Admissions';
                Image = ExecuteBatch;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    ACAAdmImportedJABBuffer: Record UnknownRecord70082;
                begin
                    if Confirm('Process Selected Student/s?',true)=false then  Error('Cancelled!');
                        Clear(ACAAdmImportedJABBuffer);
                        ACAAdmImportedJABBuffer.Reset;
                        ACAAdmImportedJABBuffer.SetRange(Selected,true);
                        ACAAdmImportedJABBuffer.SetRange(Processed,false);
                        ACAAdmImportedJABBuffer.SetFilter("Academic Year",'%1',Rec.Code);
                        if ACAAdmImportedJABBuffer.Find('-') then begin
                          Report.Run(51348,false,false,ACAAdmImportedJABBuffer);
                          end;
                        CurrPage.Update;
                end;
            }
            action(SendNotifications)
            {
                ApplicationArea = Basic;
                Caption = 'Send Notifications';
                Image = SendConfirmation;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    SendMailNoticiations: Codeunit "SendMails Easy";
                    KUCCPSImports: Record UnknownRecord70082;
                    webportals: Codeunit webportals;
                begin
                    if Confirm('Send email notification to Prospective Students?',true)= false  then  Error('Mail sending cancelled');
                    Clear(KUCCPSImports);
                    KUCCPSImports.Reset;
                    //KUCCPSImports.SETRANGE(Processed,FALSE);
                    KUCCPSImports.SetFilter(Email,'<>%1','');
                    KUCCPSImports.SetFilter("Academic Year",'%1',Rec.Code);
                    KUCCPSImports.SetFilter("Email Notification Send",'%1',false);
                    if KUCCPSImports.Find('-') then begin
                      repeat
                        begin
                        Clear(OTPNumber);
                        Randomize();
                        OTPNumber := Format(Random(9));
                       // RANDOMIZE();
                        OTPNumber := OTPNumber+Format(Random(9));
                        //RANDOMIZE();
                        OTPNumber := OTPNumber+Format(Random(9));
                       // RANDOMIZE();
                        OTPNumber := OTPNumber+Format(Random(9));
                        SendMailNoticiations.SendEmailEasy('Dear ','Karatina University Admisions','thank you for choosing Karatina University.',
                        'You are required to start your Admission process by filling in your details on the self-admission portalPortal by '+
                        'clicking on <a href = "http://172.16.0.108:81/Registered/">this link</a> to update your profile '+
                        ' and do self admission. Use Username: '+KUCCPSImports.Admin+', Password: '+OTPNumber+' as your login credentials.',
                        'Disclaimer: This notification is for information purposes only and does not imply full admission','Disclaimer.....',
                        KUCCPSImports.Email,'SELF-ADMISION NOTIFICATION');

                    // Send SMS
                    if ((KUCCPSImports.Phone <> '') and (KUCCPSImports."Email Notification Send" = false)) then begin
                    webportals.Send_SMS_Easy(KUCCPSImports.Phone,'Thank you for choosing Karatina University.',
                      'Welcome to Karatina University.Use Admission Number to log into https://admissions.karu.ac.ke, self-register for admission and book hostel.Registrar (AA)',
                      '');
                      end;

                        KUCCPSImports."Email Notification Send" := true;
                        KUCCPSImports.OTP :=OTPNumber;
                        KUCCPSImports.Modify;
                        end;
                        until KUCCPSImports.Next = 0;
                      Message('Notifications have been send.');
                      end else Error('Nothing to update ');
                end;
            }
        }
    }

    var
        OTPNumber: Code[4];
        ACAAcademicYear: Record UnknownRecord61382;
        ACANewStudDocSetup: Record UnknownRecord77361;
        ACANewStudDocuments: Record UnknownRecord77360;
        AdmissionDocumentApprovers: Record UnknownRecord77362;
        AdmissionApprovalEntries: Record UnknownRecord77391;
}

