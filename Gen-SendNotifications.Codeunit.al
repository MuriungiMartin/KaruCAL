#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 61110 "Gen-Send Notifications"
{

    trigger OnRun()
    var
        mailIDs: Text[150];
        HRMLeaveRequisition: Record UnknownRecord61125;
        ApprovalEntry: Record "Approval Entry";
        SendMailsEasy: Codeunit "SendMails Easy";
        UserSetup: Record "User Setup";
        HRMEmployeeC: Record UnknownRecord61188;
    begin
        // HRMLeaveRequisition.RESET;
        // HRMLeaveRequisition.SETFILTER("Return Date",'%1',TODAY);
        // HRMLeaveRequisition.SETFILTER("Return Mail Send",'%1',FALSE);
        // IF HRMLeaveRequisition.FIND('-') THEN BEGIN
        //  REPEAT
        //      BEGIN
        //                  HRMLeaveRequisition."Return Mail Send":=TRUE;
        //                  HRMLeaveRequisition.MODIFY;
        //      END;
        //    UNTIL HRMLeaveRequisition.NEXT=0;
        //    END;

        HRMLeaveRequisition.Reset;
        HRMLeaveRequisition.SetFilter("Return Date",'%1',Today);
        HRMLeaveRequisition.SetFilter("Return Mail Send",'%1',false);
        if HRMLeaveRequisition.Find('-') then begin
          repeat
              begin
              ////////////////////////////////-- Send mail to releaver
              if HRMLeaveRequisition."Reliever No." <>'' then begin
                          HRMEmployeeC.Reset;
                          HRMEmployeeC.SetRange("No.",HRMLeaveRequisition."Reliever No.");
                          if HRMEmployeeC.Find('-') then begin
                             Clear(mailIDs);
                            if HRMEmployeeC."Company E-Mail"<>'' then mailIDs:=HRMEmployeeC."Company E-Mail";
                          if mailIDs<>'' then begin
                          SendMailsEasy.SendEmailEasy(HRMEmployeeC.Initials,HRMEmployeeC."First Name",
                          'Leave Application for employee with PF no: '+HRMLeaveRequisition."Employee No"+', Name: '+
                          HRMLeaveRequisition."Employee Name"+' has been send for Approval. This mail is send to you'+
                           ' by virtue of you having been picked as his/her releaver. Kindly accept/reject this request as a reliever on the staff portal under LEAVE APPROVALS',
                          'Kindly take note.','THIS IS A SYSTEM GENERATED MAIL.','DO NOT RESPOND TO THIS EMAIL.',
                          mailIDs,'  ');
                          HRMLeaveRequisition."Return Mail Send":=true;
                          HRMLeaveRequisition.Modify;
                          end;
                          end;
                          end;
              ////////////////////////////////
                ApprovalEntry.Reset;
                ApprovalEntry.SetFilter("Document Type",'%1',ApprovalEntry."document type"::"Leave Application");
                ApprovalEntry.SetRange("Document No.",HRMLeaveRequisition."No.");
                if ApprovalEntry.Find('-') then begin
                  repeat
                      begin
                        UserSetup.Reset;
                        UserSetup.SetRange("User ID",ApprovalEntry."Approver ID");
                        if UserSetup.Find('-') then begin
                          HRMEmployeeC.Reset;
                          HRMEmployeeC.SetRange("No.",UserSetup."Employee No.");
                          if HRMEmployeeC.Find('-') then begin
                            Clear(mailIDs);
                            if HRMEmployeeC."Company E-Mail"<>'' then mailIDs:=HRMEmployeeC."Company E-Mail"
                            else mailIDs:=UserSetup."E-Mail";
                          //Send Mail Notification
                          if mailIDs<>'' then
                          SendMailsEasy.SendEmailEasy(HRMEmployeeC.Initials,HRMEmployeeC."First Name",
                          'Employee with PF no: '+HRMLeaveRequisition."Employee No"+', Name: '+HRMLeaveRequisition."Employee Name"+' returns from Leave today.',
                          'Kindly take note.','THIS IS A SYSTEM GENERATED MAIL.','DO NOT RESPOND TO THIS EMAIL.',
                          mailIDs,'  ');
                          end else begin

                            end;
                          end;
                      end;
                    until ApprovalEntry.Next=0;
                  end;
              end;
            until HRMLeaveRequisition.Next=0;
          end;

    end;


    procedure LeaveReturnNotification()
    var
        HRMLeaveRequisition: Record UnknownRecord61125;
        ApprovalEntry: Record "Approval Entry";
        SendMailsEasy: Codeunit "SendMails Easy";
        UserSetup: Record "User Setup";
        HRMEmployeeC: Record UnknownRecord61188;
        mailIDs: Text[150];
    begin
    end;


    procedure NotifyOnLeaveApproval(Docnoz: Code[20])
    var
        HRMLeaveRequisition: Record UnknownRecord61125;
        ApprovalEntry: Record "Approval Entry";
        SendMailsEasy: Codeunit "SendMails Easy";
        UserSetup: Record "User Setup";
        HRMEmployeeC: Record UnknownRecord61188;
        mailIDs: Text[150];
    begin
        HRMLeaveRequisition.Reset;
        HRMLeaveRequisition.SetFilter("No.",'%1',Docnoz);
        if HRMLeaveRequisition.Find('-') then begin
          repeat
              begin

              ////////////////////////////////-- Send mail to releaver
              if HRMLeaveRequisition."Reliever No." <>'' then begin
                          HRMEmployeeC.Reset;
                          HRMEmployeeC.SetRange("No.",HRMLeaveRequisition."Reliever No.");
                          if HRMEmployeeC.Find('-') then begin
                             Clear(mailIDs);
                            if HRMEmployeeC."Company E-Mail"<>'' then mailIDs:=HRMEmployeeC."Company E-Mail";
                          if mailIDs<>'' then
                          SendMailsEasy.SendEmailEasy(HRMEmployeeC.Initials,HRMEmployeeC."First Name",
                          'Leave Application for employee with PF no: '+HRMLeaveRequisition."Employee No"+', Name: '+
                          HRMLeaveRequisition."Employee Name"+' has been APPROVED. This mail is send to you'+
                           ' by virtue of you having been picked as a releaver.',
                          'Kindly take note.','THIS IS A SYSTEM GENERATED MAIL.','DO NOT RESPOND TO THIS EMAIL.',
                          mailIDs,'  ');
                          end;
                          end;
              ////////////////////////////////
                ApprovalEntry.Reset;
                ApprovalEntry.SetFilter("Document Type",'%1',ApprovalEntry."document type"::"Leave Application");
                ApprovalEntry.SetRange("Document No.",HRMLeaveRequisition."No.");
                if ApprovalEntry.Find('-') then begin
                  repeat
                      begin
                        UserSetup.Reset;
                        UserSetup.SetRange("User ID",ApprovalEntry."Approver ID");
                        if UserSetup.Find('-') then begin
                          HRMEmployeeC.Reset;
                          HRMEmployeeC.SetRange("No.",UserSetup."Employee No.");
                          if HRMEmployeeC.Find('-') then begin
                            Clear(mailIDs);
                            if HRMEmployeeC."Company E-Mail"<>'' then mailIDs:=HRMEmployeeC."Company E-Mail"
                            else mailIDs:=UserSetup."E-Mail";
                          //Send Mail Notification
                          if mailIDs<>'' then
                          SendMailsEasy.SendEmailEasy(HRMEmployeeC.Initials,HRMEmployeeC."First Name",
                          'Leave Application for employee with PF no: '+HRMLeaveRequisition."Employee No"+', Name: '+HRMLeaveRequisition."Employee Name"+' has been APPROVED.',
                          'Kindly take note.','THIS IS A SYSTEM GENERATED MAIL.','DO NOT RESPOND TO THIS EMAIL UNLESS YOU WANT TO TALK TO A COMPUTER',
                          mailIDs,'The return date for this application will be: '+Format(HRMLeaveRequisition."Return Date"));
                          end else begin

                            end;
                          end;
                      end;
                    until ApprovalEntry.Next=0;
                  end;
              end;
            until HRMLeaveRequisition.Next=0;
          end;
    end;


    procedure ReleaverLeaveNotification(Docnoz: Code[20])
    var
        HRMLeaveRequisition: Record UnknownRecord61125;
        ApprovalEntry: Record "Approval Entry";
        SendMailsEasy: Codeunit "SendMails Easy";
        UserSetup: Record "User Setup";
        HRMEmployeeC: Record UnknownRecord61188;
        mailIDs: Text[150];
    begin
        HRMLeaveRequisition.Reset;
        HRMLeaveRequisition.SetFilter("No.",'%1',Docnoz);
        if HRMLeaveRequisition.Find('-') then begin
          repeat
              begin

              ////////////////////////////////-- Send mail to releaver
              if HRMLeaveRequisition."Reliever No." <>'' then begin
                          HRMEmployeeC.Reset;
                          HRMEmployeeC.SetRange("No.",HRMLeaveRequisition."Reliever No.");
                          if HRMEmployeeC.Find('-') then begin
                             Clear(mailIDs);
                            if HRMEmployeeC."Company E-Mail"<>'' then mailIDs:=HRMEmployeeC."Company E-Mail";
                          if mailIDs<>'' then begin
                            if HRMLeaveRequisition."Reliever Mail is Send" = false then
                          SendMailsEasy.SendEmailEasy(HRMEmployeeC.Initials,HRMEmployeeC."First Name",
                          'Leave Application for employee with PF no: '+HRMLeaveRequisition."Employee No"+', Name: '+
                          HRMLeaveRequisition."Employee Name"+' has been send for Approval. This mail is send to you'+
                           ' by virtue of you having been picked as his/her releaver. Kindly accept/reject this request as a reliever on the staff portal under LEAVE APPROVALS',
                          'Kindly take note.','THIS IS A SYSTEM GENERATED MAIL.','DO NOT RESPOND TO THIS EMAIL.',
                          mailIDs,'  ');
                          HRMLeaveRequisition."Reliever Mail is Send":=true;
                          HRMLeaveRequisition.Modify;
                          end;
                          end;
                          end;
              ////////////////////////////////
              end;
            until HRMLeaveRequisition.Next=0;
          end;

    end;
}

