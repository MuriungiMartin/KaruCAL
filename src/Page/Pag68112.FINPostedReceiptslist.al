#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68112 "FIN-Posted Receipts list"
{
    ApplicationArea = Basic;
    CardPageID = "FIN-Posted Receipt UP";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61723;
    SourceTableView = where(Posted=filter(Yes));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Cashier;Cashier)
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
                field(Control8;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Code";"Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field("Received From";"Received From")
                {
                    ApplicationArea = Basic;
                }
                field("On Behalf Of";"On Behalf Of")
                {
                    ApplicationArea = Basic;
                }
                field("Amount Recieved";"Amount Recieved")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Factor";"Currency Factor")
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount";"Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Posted By";"Posted By")
                {
                    ApplicationArea = Basic;
                }
                field("Print No.";"Print No.")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No.";"Cheque No.")
                {
                    ApplicationArea = Basic;
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
                field("Created Date Time";"Created Date Time")
                {
                    ApplicationArea = Basic;
                }
                field("Register No.";"Register No.")
                {
                    ApplicationArea = Basic;
                }
                field("From Entry No.";"From Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("To Entry No.";"To Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
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
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Appointment No";"Patient Appointment No")
                {
                    ApplicationArea = Basic;
                }
                field("Surrender No";"Surrender No")
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
            action("Posted Receipt Card")
            {
                ApplicationArea = Basic;
                Image = PostedDeposit;
                RunObject = Page "FIN-Posted Receipt UP";
                RunPageLink = "No."=field("No.");
            }
        }
    }
}

