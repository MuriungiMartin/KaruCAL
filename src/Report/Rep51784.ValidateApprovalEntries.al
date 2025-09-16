#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51784 "Validate Approval Entries"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Approval Entry";"Approval Entry")
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   addApprovers.Reset;
                   addApprovers.SetRange(addApprovers."Approver ID","Approval Entry"."Approver ID");
                   addApprovers.SetRange(addApprovers."Approval Code","Approval Entry"."Approval Code");
                   addApprovers.SetRange(addApprovers."Approval Type","Approval Entry"."Approval Type");
                   addApprovers.SetRange(addApprovers."Document Type","Approval Entry"."Document Type");
                  // addApprovers.SETRANGE(addApprovers."Sequence No.","Approval Entry"."Sequence No.");
                   if addApprovers.Find('-') then begin
                      begin
                        GroupApps.Reset;
                        GroupApps.SetRange(GroupApps."Approval Code",addApprovers."Approval Code");
                        GroupApps.SetRange(GroupApps."Approval Type",addApprovers."Approval Type");
                        GroupApps.SetRange(GroupApps."Document Type",addApprovers."Document Type");
                        GroupApps.SetRange(GroupApps."Sequence No.",addApprovers."Sequence No.");
                     //   GroupApps.SETRANGE(GroupApps."Limit Type",addApprovers."Limit Type");
                        if GroupApps.Find('-') then begin
                           repeat
                            begin
                            appentry.Reset;
                           // appentry.SETRANGE(appentry."Table ID","Approval Entry"."Table ID");
                           // appentry.SETRANGE(appentry."Document Type","Approval Entry"."Document Type");
                           // appentry.SETRANGE(appentry."Document No.","Approval Entry"."Document No.");
                           // appentry.SETRANGE(appentry."Sequence No.",GroupApps."Sequence No.");
                           // appentry.SETRANGE(appentry."Approver ID",GroupApps."Approver ID");
                             if not (appentry.Get("Approval Entry"."Table ID","Approval Entry"."Document Type","Approval Entry"."Document No.",
                             "Approval Entry"."Sequence No.",GroupApps."Approver ID")) then begin
                              //insert into the ledger entry table
                             // IF NOT (appentry.FIND('-'))  THEN BEGIN
                              appentry.Init;
                              appentry."Table ID":="Approval Entry"."Table ID";
                              appentry."Document Type":="Approval Entry"."Document Type";
                              appentry."Document No.":="Approval Entry"."Document No.";
                              appentry."Sequence No.":="Approval Entry"."Sequence No.";
                              appentry."Approver ID":=GroupApps."Approver ID";;
                              appentry."Approval Code":="Approval Entry"."Approval Code";
                              appentry."Sender ID":="Approval Entry"."Sender ID";
                              appentry."Salespers./Purch. Code":="Approval Entry"."Salespers./Purch. Code";
                              appentry.Status:="Approval Entry".Status;
                              appentry."Date-Time Sent for Approval":="Approval Entry"."Date-Time Sent for Approval";
                              appentry."Last Date-Time Modified":="Approval Entry"."Last Date-Time Modified";
                              appentry."Last Modified By ID":= "Approval Entry"."Last Modified By ID";
                              appentry."Due Date":= "Approval Entry"."Due Date";
                              appentry.Amount:="Approval Entry".Amount;
                              appentry."Amount (LCY)":="Approval Entry"."Amount (LCY)";
                              appentry."Currency Code":= "Approval Entry"."Currency Code";
                              appentry."Approval Type":="Approval Entry"."Approval Type";
                              appentry."Limit Type":= "Approval Entry"."Limit Type";
                              appentry."Available Credit Limit (LCY)":= "Approval Entry"."Available Credit Limit (LCY)";
                              appentry.Comment:="Approval Entry".Comment;
                              appentry.Insert;
                             end;
                            end;
                           until GroupApps.Next=0;
                        end;
                      end;
                   end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        addApprovers: Record UnknownRecord465;
        GroupApps: Record UnknownRecord61240;
        appentry: Record "Approval Entry";
}

