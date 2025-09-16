#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51268 "Hotel Food Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hotel Food Receipt.rdlc';

    dataset
    {
        dataitem(UnknownTable61170;UnknownTable61170)
        {
            column(ReportForNavId_9620; 9620)
            {
            }
            column(Reg;Reg)
            {
            }
            column(Menu_Sale_Header__Receipt_No_;"Receipt No")
            {
            }
            column(Menu_Sale_Header__Paid_Amount_;"Paid Amount")
            {
            }
            column(Menu_Sale_Header_Balance;Balance)
            {
            }
            column(KISUMU_HOTELCaption;KISUMU_HOTELCaptionLbl)
            {
            }
            column(CALL_AGAINCaption;CALL_AGAINCaptionLbl)
            {
            }
            column(REG_Caption;REG_CaptionLbl)
            {
            }
            column(Tel____254_057_2024157__2022833_2027780_0722203410Caption;Tel____254_057_2024157__2022833_2027780_0722203410CaptionLbl)
            {
            }
            column(P_O__BOX_3335_KISUMU__KENYACaption;P_O__BOX_3335_KISUMU__KENYACaptionLbl)
            {
            }
            column(Menu_Sale_Header__Paid_Amount_Caption;FieldCaption("Paid Amount"))
            {
            }
            column(Menu_Sale_Header_BalanceCaption;FieldCaption(Balance))
            {
            }
            dataitem(UnknownTable61173;UnknownTable61173)
            {
                DataItemLink = "Receipt No"=field("Receipt No");
                DataItemTableView = sorting("Line No",Menu,"Receipt No") order(ascending);
                column(ReportForNavId_8025; 8025)
                {
                }
                column(Menu_Sales_Line__Unit_Cost_;"Unit Cost")
                {
                }
                column(Menu_Sales_Line_Quantity;Quantity)
                {
                }
                column(Menu_Sales_Line_Amount;Amount)
                {
                }
                column(Menu_Sales_Line_Description;Description)
                {
                }
                column(Menu_Sales_Line_Amount_Control1000000012;Amount)
                {
                }
                column(TotalCaption;TotalCaptionLbl)
                {
                }
                column(Menu_Sales_Line_Line_No;"Line No")
                {
                }
                column(Menu_Sales_Line_Menu;Menu)
                {
                }
                column(Menu_Sales_Line_Receipt_No;"Receipt No")
                {
                }
            }
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
        Reg: Code[20];
        KISUMU_HOTELCaptionLbl: label 'KISUMU HOTEL';
        CALL_AGAINCaptionLbl: label 'CALL AGAIN';
        REG_CaptionLbl: label 'REG:';
        Tel____254_057_2024157__2022833_2027780_0722203410CaptionLbl: label 'Tel : +254 057 2024157/ 2022833/2027780/0722203410';
        P_O__BOX_3335_KISUMU__KENYACaptionLbl: label 'P.O. BOX 3335 KISUMU, KENYA';
        TotalCaptionLbl: label 'Total';
}

