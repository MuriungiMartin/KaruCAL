#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 249 "VAT Registration Log"
{
    Caption = 'Tax Registration Log';
    DataCaptionFields = "Account Type","Account No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "VAT Registration Log";
    SourceTableView = sorting("Entry No.")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the verification action.';
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("VAT Registration No.";"VAT Registration No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax registration number that you entered in the Tax Registration No. field on a customer, vendor, or contact card.';
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the account type of the customer or vendor whose tax registration number is verified.';
                    Visible = false;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the account number of the customer or vendor whose tax registration number is verified.';
                    Visible = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the status of the verification action.';
                }
                field("Verified Date";"Verified Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies when the tax registration number was verified.';
                }
                field("Verified Name";"Verified Name")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer, vendor, or contact whose tax registration number was verified.';
                }
                field("Verified Address";"Verified Address")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the address of the customer, vendor, or contact whose tax registration number was verified.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the user who verified the tax registration number.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Verify Registration No.")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Verify Registration No.';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Codeunit "VAT Lookup Ext. Data Hndl";
                ToolTip = 'Verify a Tax registration number. If the number is verified the status field contains the value Valid.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        if FindFirst then;
    end;
}

