#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50653 "Interbank Transfer"
{
    CardPageID = "Bank & Cash Transfer Reques UP";
    PageType = List;
    SourceTable = "HMS-Medical Conditions";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Pay Mode";"Pay Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Account";"Receiving Account")
                {
                    ApplicationArea = Basic;
                }
                field("Received From";"Received From")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Bank Account Name";"Receiving Bank Account Name")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Date Posted";"Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Time Posted";"Time Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Posted By";"Posted By")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Name";"Transaction Name")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Paying Account";"Paying Account")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Type";"Bank Type")
                {
                    ApplicationArea = Basic;
                }
                field("Source Depot Code";"Source Depot Code")
                {
                    ApplicationArea = Basic;
                }
                field("Source Department Code";"Source Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Source Depot Name";"Source Depot Name")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Depot Code";"Receiving Depot Code")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Department Code";"Receiving Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Depot Name";"Receiving Depot Name")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Department Name";"Receiving Department Name")
                {
                    ApplicationArea = Basic;
                }
                field("Source Department Name";"Source Department Name")
                {
                    ApplicationArea = Basic;
                }
                field("Paying  Bank Account Name";"Paying  Bank Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Inter Bank Template Name";"Inter Bank Template Name")
                {
                    ApplicationArea = Basic;
                }
                field("Inter Bank Journal Batch";"Inter Bank Journal Batch")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Transfer Type";"Receiving Transfer Type")
                {
                    ApplicationArea = Basic;
                }
                field("Source Transfer Type";"Source Transfer Type")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code Destination";"Currency Code Destination")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code Source";"Currency Code Source")
                {
                    ApplicationArea = Basic;
                }
                field("Amount 2";"Amount 2")
                {
                    ApplicationArea = Basic;
                }
                field("Exch. Rate Source";"Exch. Rate Source")
                {
                    ApplicationArea = Basic;
                }
                field("Exch. Rate Destination";"Exch. Rate Destination")
                {
                    ApplicationArea = Basic;
                }
                field("Reciprical 1";"Reciprical 1")
                {
                    ApplicationArea = Basic;
                }
                field("Reciprical 2";"Reciprical 2")
                {
                    ApplicationArea = Basic;
                }
                field("Balance 1";"Balance 1")
                {
                    ApplicationArea = Basic;
                }
                field("Balance 2";"Balance 2")
                {
                    ApplicationArea = Basic;
                }
                field("Current Source A/C Bal.";"Current Source A/C Bal.")
                {
                    ApplicationArea = Basic;
                }
                field("Register Number";"Register Number")
                {
                    ApplicationArea = Basic;
                }
                field("From No";"From No")
                {
                    ApplicationArea = Basic;
                }
                field("To No";"To No")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 4 Code";"Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Dim3;Dim3)
                {
                    ApplicationArea = Basic;
                }
                field(Dim4;Dim4)
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 3 Code1";"Shortcut Dimension 3 Code1")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 4 Code1";"Shortcut Dimension 4 Code1")
                {
                    ApplicationArea = Basic;
                }
                field(Dim31;Dim31)
                {
                    ApplicationArea = Basic;
                }
                field(Dim41;Dim41)
                {
                    ApplicationArea = Basic;
                }
                field("Sending Responsibility Center";"Sending Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Reciept Responsibility Center";"Reciept Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Sending Resp Centre";"Sending Resp Centre")
                {
                    ApplicationArea = Basic;
                }
                field("Receipt Resp Centre";"Receipt Resp Centre")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
                field("Request Amt LCY";"Request Amt LCY")
                {
                    ApplicationArea = Basic;
                }
                field("Pay Amt LCY";"Pay Amt LCY")
                {
                    ApplicationArea = Basic;
                }
                field("External Doc No.";"External Doc No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer Release Date";"Transfer Release Date")
                {
                    ApplicationArea = Basic;
                }
                field("Cancelled By";"Cancelled By")
                {
                    ApplicationArea = Basic;
                }
                field("Date Cancelled";"Date Cancelled")
                {
                    ApplicationArea = Basic;
                }
                field("Time Cancelled";"Time Cancelled")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Posted Interbank Transfers")
            {
                ApplicationArea = Basic;
                RunObject = Page "HRM-Appraisal Setup 3";
                RunPageLink = No=field(No);
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
          Rcpt.Reset;
          Rcpt.SetRange(Rcpt.Posted,false);
          Rcpt.SetRange(Rcpt."Created By",UserId);
          if Rcpt.Count >0 then
            begin
              if Confirm('There are still some unposted imprest Surrenders. Continue?',false)=false then
                begin
                  Error('There are still some unposted imprest Surrenders. Please utilise them first');
                end;
            end;
    end;

    var
        Rcpt: Record "HMS-Medical Conditions";
}

