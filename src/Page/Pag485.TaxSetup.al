#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 485 "Tax Setup"
{
    ApplicationArea = Basic;
    Caption = 'Tax Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Tax Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Auto. Create Tax Details";"Auto. Create Tax Details")
                {
                    ApplicationArea = Basic;
                }
                field("Non-Taxable Tax Group Code";"Non-Taxable Tax Group Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Default Accounts")
            {
                Caption = 'Default Accounts';
                field("Tax Account (Sales)";"Tax Account (Sales)")
                {
                    ApplicationArea = Basic;
                }
                field("Tax Account (Purchases)";"Tax Account (Purchases)")
                {
                    ApplicationArea = Basic;
                }
                field("Unreal. Tax Acc. (Sales)";"Unreal. Tax Acc. (Sales)")
                {
                    ApplicationArea = Basic;
                }
                field("Unreal. Tax Acc. (Purchases)";"Unreal. Tax Acc. (Purchases)")
                {
                    ApplicationArea = Basic;
                }
                field("Reverse Charge (Purchases)";"Reverse Charge (Purchases)")
                {
                    ApplicationArea = Basic;
                }
                field("Unreal. Rev. Charge (Purch.)";"Unreal. Rev. Charge (Purch.)")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

