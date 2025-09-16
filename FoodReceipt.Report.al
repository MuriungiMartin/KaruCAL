#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51240 "Food Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Food Receipt.rdlc';

    dataset
    {
        dataitem(UnknownTable61170;UnknownTable61170)
        {
            column(ReportForNavId_9620; 9620)
            {
            }
            column(Menu_Sale_Header__Sales_Point_;"Sales Point")
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
            column(Menu_Sale_Header__Cashier_Name_;"Cashier Name")
            {
            }
            column(CHUKACaption;CHUKACaptionLbl)
            {
            }
            column(UniversityCaption;UniversityCaptionLbl)
            {
            }
            column(CALL_AGAINCaption;CALL_AGAINCaptionLbl)
            {
            }
            column(REG_Caption;REG_CaptionLbl)
            {
            }
            column(Menu_Sale_Header__Paid_Amount_Caption;FieldCaption("Paid Amount"))
            {
            }
            column(PrepBalBef;PrepBalAf)
            {
            }
            column(PrepBalAf;PrepBalBef)
            {
            }
            column(Secur;SecFo)
            {
            }
            column(Menu_Sale_Header_BalanceCaption;FieldCaption(Balance))
            {
            }
            column(SalesType;"CAT-Menu Sale Header"."Sales Type")
            {
            }
            column(Date_Menu;"CAT-Menu Sale Header".Date)
            {
            }
            column(CustomerNo;"CAT-Menu Sale Header"."Customer No")
            {
            }
            dataitem(UnknownTable61173;UnknownTable61173)
            {
                DataItemLink = "Receipt No"=field("Receipt No");
                DataItemTableView = sorting("Line No","Receipt No") order(ascending);
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

            trigger OnAfterGetRecord()
            begin
                    "CAT-Menu Sale Header".CalcFields("CAT-Menu Sale Header"."Prepayment Balance");
                    "CAT-Menu Sale Header".CalcFields("CAT-Menu Sale Header".Amount);
                     PrepBalBef:="CAT-Menu Sale Header"."Prepayment Balance";
                     if PrepBalBef<>0 then
                     PrepBalAf:="CAT-Menu Sale Header"."Prepayment Balance"-"CAT-Menu Sale Header".Amount;

                     Sec:=010101T-Time;
                     SecFo:=Format(Sec);
                     "CAT-Menu Sale Header"."Last Sc":=Format(Sec);
                     "CAT-Menu Sale Header".Modify;
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
        Reg: Code[20];
        CHUKACaptionLbl: label 'CHUKA';
        UniversityCaptionLbl: label 'University';
        CALL_AGAINCaptionLbl: label 'CALL AGAIN';
        REG_CaptionLbl: label 'REG:';
        TotalCaptionLbl: label 'Total';
        PrepBalBef: Decimal;
        PrepBalAf: Decimal;
        Sec: Integer;
        SecFo: Text;
}

