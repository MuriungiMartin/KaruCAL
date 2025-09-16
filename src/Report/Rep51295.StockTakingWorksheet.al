#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51295 "Stock Taking Worksheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Stock Taking Worksheet.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Inventory Posting Group";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Location;Location)
            {
            }
            column(Item__Inventory_Posting_Group_;"Inventory Posting Group")
            {
            }
            column(RegNo;RegNo)
            {
            }
            column(Year__;"Year.")
            {
            }
            column(Item__No__;"No.")
            {
            }
            column(Item_Description;Description)
            {
            }
            column(Item__Base_Unit_of_Measure_;"Base Unit of Measure")
            {
            }
            column(STOCK_TAKING_AND_STOCK_ADJUSTMENT_FORMCaption;STOCK_TAKING_AND_STOCK_ADJUSTMENT_FORMCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(NAMECaption;NAMECaptionLbl)
            {
            }
            column(DATE__________________________________________Caption;DATE__________________________________________CaptionLbl)
            {
            }
            column(REG_NO__________________________________________Caption;REG_NO__________________________________________CaptionLbl)
            {
            }
            column(Item__Inventory_Posting_Group_Caption;FieldCaption("Inventory Posting Group"))
            {
            }
            column(NOCaption;NOCaptionLbl)
            {
            }
            column(DESCRIPTIONCaption;DESCRIPTIONCaptionLbl)
            {
            }
            column(UNITSCaption;UNITSCaptionLbl)
            {
            }
            column(UNIT_PRICECaption;UNIT_PRICECaptionLbl)
            {
            }
            column(BOOK_BAL_Caption;BOOK_BAL_CaptionLbl)
            {
            }
            column(BOOK_VAL_Caption;BOOK_VAL_CaptionLbl)
            {
            }
            column(PHY_BALCaption;PHY_BALCaptionLbl)
            {
            }
            column(PHY_VALCaption;PHY_VALCaptionLbl)
            {
            }
            column(DEF__BALCaption;DEF__BALCaptionLbl)
            {
            }
            column(DEF__VALCaption;DEF__VALCaptionLbl)
            {
            }
            column(SURP_BAL_Caption;SURP_BAL_CaptionLbl)
            {
            }
            column(SURP__VALCaption;SURP__VALCaptionLbl)
            {
            }
            column(EXPLANATION_ON_DEF_SURPCaption;EXPLANATION_ON_DEF_SURPCaptionLbl)
            {
            }
            column(DataItem1000000052;V1__We_herby_certify_that_we_have_this_day_taken_physical_stock_count_of_items_commodities_enumerated_above_and_we_are_satisfLbl)
            {
            }
            column(Stores_Clerk_i_c_____________________________________________Caption;Stores_Clerk_i_c_____________________________________________CaptionLbl)
            {
            }
            column(Principal_Checking_Officer__________________________________________Caption;Principal_Checking_Officer__________________________________________CaptionLbl)
            {
            }
            column(Audit__Internal_External_________________________________________Caption;Audit__Internal_External_________________________________________CaptionLbl)
            {
            }
            column(V2__Final_approval_to_the_adjustment_of_records_is_hereby_authorized_Caption;V2__Final_approval_to_the_adjustment_of_records_is_hereby_authorized_CaptionLbl)
            {
            }
            column(Accounting_Officer_____________________________________________Caption;Accounting_Officer_____________________________________________CaptionLbl)
            {
            }
            column(Date_____________________________________Caption;Date_____________________________________CaptionLbl)
            {
            }
            column(Signature_____________________________Caption;Signature_____________________________CaptionLbl)
            {
            }
            column(Signature_____________________________Caption_Control1000000066;Signature_____________________________Caption_Control1000000066Lbl)
            {
            }
            column(Date_____________________________________Caption_Control1000000067;Date_____________________________________Caption_Control1000000067Lbl)
            {
            }
            column(Signature_____________________________Caption_Control1000000068;Signature_____________________________Caption_Control1000000068Lbl)
            {
            }
            column(Date_____________________________________Caption_Control1000000069;Date_____________________________________Caption_Control1000000069Lbl)
            {
            }
            column(Signature_____________________________Caption_Control1000000070;Signature_____________________________Caption_Control1000000070Lbl)
            {
            }
            column(Date_____________________________________Caption_Control1000000071;Date_____________________________________Caption_Control1000000071Lbl)
            {
            }
            column(Name_Caption;Name_CaptionLbl)
            {
            }
            column(Name_Caption_Control1000000073;Name_Caption_Control1000000073Lbl)
            {
            }
            column(Name_Caption_Control1000000074;Name_Caption_Control1000000074Lbl)
            {
            }
            column(Name_Caption_Control1000000075;Name_Caption_Control1000000075Lbl)
            {
            }
            dataitem("Item Ledger Entry";"Item Ledger Entry")
            {
                DataItemLink = "Item No."=field("No.");
                column(ReportForNavId_7209; 7209)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Location:="Item Ledger Entry"."Location Code";
                end;
            }

            trigger OnPreDataItem()
            begin
                 RegNo:=RegNo+'0000';
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
        Location: Text[30];
        RegNo: Code[10];
        "Year.": Code[20];
        STOCK_TAKING_AND_STOCK_ADJUSTMENT_FORMCaptionLbl: label 'STOCK TAKING AND STOCK ADJUSTMENT FORM';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NAMECaptionLbl: label 'NAME';
        DATE__________________________________________CaptionLbl: label 'DATE..........................................';
        REG_NO__________________________________________CaptionLbl: label 'REG NO..........................................';
        NOCaptionLbl: label 'NO';
        DESCRIPTIONCaptionLbl: label 'DESCRIPTION';
        UNITSCaptionLbl: label 'UNITS';
        UNIT_PRICECaptionLbl: label 'UNIT PRICE';
        BOOK_BAL_CaptionLbl: label 'BOOK BAL.';
        BOOK_VAL_CaptionLbl: label 'BOOK VAL.';
        PHY_BALCaptionLbl: label 'PHY BAL';
        PHY_VALCaptionLbl: label 'PHY VAL';
        DEF__BALCaptionLbl: label 'DEF. BAL';
        DEF__VALCaptionLbl: label 'DEF. VAL';
        SURP_BAL_CaptionLbl: label 'SURP BAL.';
        SURP__VALCaptionLbl: label 'SURP. VAL';
        EXPLANATION_ON_DEF_SURPCaptionLbl: label 'EXPLANATION ON DEF/SURP';
        V1__We_herby_certify_that_we_have_this_day_taken_physical_stock_count_of_items_commodities_enumerated_above_and_we_are_satisfLbl: label '1. We herby certify that we have this day taken physical stock count of items/commodities enumerated above and we are satisfied that the figures are correct.';
        Stores_Clerk_i_c_____________________________________________CaptionLbl: label 'Stores Clerk i/c_____________________________________________';
        Principal_Checking_Officer__________________________________________CaptionLbl: label 'Principal Checking Officer__________________________________________';
        Audit__Internal_External_________________________________________CaptionLbl: label 'Audit (Internal/External) _______________________________________';
        V2__Final_approval_to_the_adjustment_of_records_is_hereby_authorized_CaptionLbl: label '2. Final approval to the adjustment of records is hereby authorized.';
        Accounting_Officer_____________________________________________CaptionLbl: label 'Accounting Officer ____________________________________________';
        Date_____________________________________CaptionLbl: label 'Date_____________________________________';
        Signature_____________________________CaptionLbl: label 'Signature_____________________________';
        Signature_____________________________Caption_Control1000000066Lbl: label 'Signature_____________________________';
        Date_____________________________________Caption_Control1000000067Lbl: label 'Date_____________________________________';
        Signature_____________________________Caption_Control1000000068Lbl: label 'Signature_____________________________';
        Date_____________________________________Caption_Control1000000069Lbl: label 'Date_____________________________________';
        Signature_____________________________Caption_Control1000000070Lbl: label 'Signature_____________________________';
        Date_____________________________________Caption_Control1000000071Lbl: label 'Date_____________________________________';
        Name_CaptionLbl: label '(Name)';
        Name_Caption_Control1000000073Lbl: label '(Name)';
        Name_Caption_Control1000000074Lbl: label '(Name)';
        Name_Caption_Control1000000075Lbl: label '(Name)';
}

