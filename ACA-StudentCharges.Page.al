#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68761 "ACA-Student Charges"
{
    PageType = List;
    SourceTable = UnknownTable61535;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Reg. Transacton ID";"Reg. Transacton ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Transacton ID";"Transacton ID")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Recovered First";"Recovered First")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Recognized;Recognized)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = true;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Distribution;Distribution)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Distribution Account";"Distribution Account")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        //IF Recognized = TRUE THEN
        //ERROR('You can not delete recognized/billed transactions.');
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if "Transaction Type" = "transaction type"::Charges then
        Validate("Transacton ID");
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Recognized = true then
;
}

