#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51831 "CAT-Cafeteria Receipts (Copy)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CAT-Cafeteria Receipts (Copy).rdlc';

    dataset
    {
        dataitem(UnknownTable61783;UnknownTable61783)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Doc. No.";
            column(ReportForNavId_1; 1)
            {
            }
            column(pic;info.Picture)
            {
            }
            column(address;Address)
            {
            }
            column(tel;Tel)
            {
            }
            column(fax;Fax)
            {
            }
            column(pin;PIN)
            {
            }
            column(email;Email)
            {
            }
            column(vat;VAT)
            {
            }
            column(dettotal;DetTotal)
            {
            }
            column(dates;Format(Today,0,4))
            {
            }
            column(recNo;"CAT-Cafeteria Receipts"."Receipt No.")
            {
            }
            column(transType;Format("CAT-Cafeteria Receipts"."Transaction Type"))
            {
            }
            column(totals;totals)
            {
            }
            column(AmountPaid;"CAT-Cafeteria Receipts".Amount)
            {
            }
            column(change;"CAT-Cafeteria Receipts".Amount-"CAT-Cafeteria Receipts"."Recept Total")
            {
            }
            column(Amounts;"CAT-Cafeteria Receipts"."Recept Total")
            {
            }
            column(creditEmp;creditEmp)
            {
            }
            column(users;'You were served by: '+"CAT-Cafeteria Receipts".User)
            {
            }
            column(BonApettie;'************** BON APETTIE **************')
            {
            }
            column(endOfReceipt;'End of Fiscal Receipt')
            {
            }
            column(double_Line;'==============================')
            {
            }
            dataitem(UnknownTable61775;UnknownTable61775)
            {
                DataItemLink = "Receipt No."=field("Receipt No.");
                column(ReportForNavId_2; 2)
                {
                }
                column(MealCode;"CAT-Cafeteria Receipts Line"."Meal Code")
                {
                }
                column(MealDesc;"CAT-Cafeteria Receipts Line"."Meal Descption")
                {
                }
                column(qty;"CAT-Cafeteria Receipts Line".Quantity)
                {
                }
                column(unitPrice;"CAT-Cafeteria Receipts Line"."Unit Price")
                {
                }
                column(TotLine_Amount;"CAT-Cafeteria Receipts Line"."Total Amount")
                {
                }

                trigger OnAfterGetRecord()
                begin

                        DetTotal:=0.0;
                        DetTotal:="CAT-Cafeteria Receipts Line".Quantity*"CAT-Cafeteria Receipts Line"."Unit Price";
                        totals:=totals+DetTotal;
                    Amounts:="CAT-Cafeteria Receipts".Amount;
                    change:="CAT-Cafeteria Receipts".Amount-totals;//"Cafeteria Receipts"."Recept Total";
                end;
            }

            trigger OnAfterGetRecord()
            begin

                  info.Reset;
                  if info.Find('-') then
                    info.CalcFields(Picture);

                Address:=info.Address+', '+info."Address 2"+', '+info.City;
                Tel:='TEL:'+info."Phone No.";
                Email:='EMAIL:'+info."E-Mail";

                //PIN:='PIN NO.: ';
                VAT:='VAT: '+info."VAT Registration No.";
                totals:=0.0;
                change:=0.0;
                "CAT-Cafeteria Receipts".CalcFields("CAT-Cafeteria Receipts"."Recept Total");
                "CAT-Cafeteria Receipts".CalcFields("CAT-Cafeteria Receipts"."Customer Name");

                "CAT-Cafeteria Receipts".CalcFields("CAT-Cafeteria Receipts"."Employee Name");

                creditEmp:='';
                if "CAT-Cafeteria Receipts"."Employee No"<>'' then
                creditEmp:="CAT-Cafeteria Receipts"."Employee No"+': '+"Employee Name";
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
        info: Record "Company Information";
        Address: Text[250];
        Tel: Code[100];
        Fax: Code[20];
        PIN: Code[20];
        Email: Text[50];
        VAT: Code[20];
        DetTotal: Decimal;
        totals: Decimal;
        change: Decimal;
        Amounts: Decimal;
        creditEmp: Code[150];
}

