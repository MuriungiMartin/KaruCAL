#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51260 "Imprest Request"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest Request.rdlc';

    dataset
    {
        dataitem("Payments Header";UnknownTable61704)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_1000000053; 1000000053)
            {
            }
            column(Payments_Header__No__;"Payments Header"."No.")
            {
            }
            column(Payments_Header_Payee;"Payments Header".Payee)
            {
            }
            column(Payments_Header__Payments_Header__Date;"Payments Header".Date)
            {
            }
            column(Payments_Header__Global_Dimension_1_Code_;"Global Dimension 1 Code")
            {
            }
            column(Account_No;"Account No.")
            {
            }
            column(Payments_Header_Purpose;Purpose)
            {
            }
            column(DptName;DptName)
            {
            }
            column(USERID;UserId)
            {
            }
            column(NumberText_1_;NumberText[1])
            {
            }
            column(TTotal;TTotal)
            {
                DecimalPlaces = 2:2;
            }
            column(TIME_PRINTED_____FORMAT_TIME_;'TIME PRINTED:' + Format(Time))
            {
                AutoFormatType = 1;
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4_;'DATE PRINTED:' + Format(Today,0,4))
            {
                AutoFormatType = 1;
            }
            column(CurrCode;CurrCode)
            {
            }
            column(TotalNetAmount_PaymentsHeader;"Payments Header"."Total Net Amount")
            {
            }
            column(Purpose;"Payments Header".Purpose)
            {
            }
            dataitem("Payment Line";UnknownTable61714)
            {
                DataItemLink = No=field("No.");
                DataItemTableView = sorting(No,"Account No:") order(ascending);
                column(ReportForNavId_1000000004; 1000000004)
                {
                }
                column(Payment_Line_Amount;Amount)
                {
                }
                column(Account_No________Account_Name_;"Account No:"+':'+"Account Name")
                {
                }
                column(Payment_Line_No;No)
                {
                }
                column(Payment_Line_Account_No_;"Account No:")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    DimVal.Reset;
                    DimVal.SetRange(DimVal."Global Dimension No.",2);
                    DimVal.SetRange(DimVal.Code,"Shortcut Dimension 2 Code");
                    DimValName:='';
                    if DimVal.FindFirst then
                      begin
                        DimValName:=DimVal.Name;
                      end;

                    TTotal:=TTotal + "Payment Line".Amount ;
                    "Payments Header".CalcFields("Payments Header"."Total Net Amount");
                    CheckReport.InitTextVariable();
                    CheckReport.FormatNoText(NumberText,"Payments Header"."Total Net Amount",'');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                StrCopyText:='';
                if "No. Printed">=1 then
                  begin
                    StrCopyText:='DUPLICATE';
                  end;
                TTotal:=0;


                //Set currcode to Default if blank
                GLSetup.Get();
                if "Payments Header"."Currency Code"='' then begin
                  CurrCode:=GLSetup."LCY Code";
                end else
                  CurrCode:="Payments Header"."Currency Code";

                //For Inv Curr Code
                if "Payments Header"."Invoice Currency Code"='' then begin
                  InvoiceCurrCode:=GLSetup."LCY Code";
                end else
                  InvoiceCurrCode:="Payments Header"."Invoice Currency Code";

                //End;
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code,"Payments Header"."Shortcut Dimension 2 Code");
                if DimVal.Find('-') then begin
                DptName:=DimVal.Name;
                end;
            end;

            trigger OnPostDataItem()
            begin
                /*
                IF CurrReport.PREVIEW=FALSE THEN
                  BEGIN
                    "No. Printed":="No. Printed" + 1;
                    MODIFY;
                  END;
                  */
                "Payments Header".CalcFields("Payments Header"."Total Net Amount");
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText,"Payments Header"."Total Net Amount",'');

            end;

            trigger OnPreDataItem()
            begin

                //LastFieldNo := FIELDNO("No.");
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
        StrCopyText: Text[250];
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        DimVal: Record "Dimension Value";
        DimValName: Text[250];
        TTotal: Decimal;
        CheckReport: Report Check;
        NumberText: array [2] of Text[250];
        STotal: Decimal;
        InvoiceCurrCode: Code[40];
        CurrCode: Code[40];
        GLSetup: Record "General Ledger Setup";
        DptName: Code[250];
}

