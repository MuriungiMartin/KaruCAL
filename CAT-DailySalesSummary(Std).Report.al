#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51811 "CAT-Daily Sales Summary (Std)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CAT-Daily Sales Summary (Std).rdlc';

    dataset
    {
        dataitem(UnknownTable61782;UnknownTable61782)
        {
            DataItemTableView = where("Cafeteria Section"=filter(Students));
            PrintOnlyIfDetail = false;
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
            column(dates;Format(Today,0,4))
            {
            }
            column(datefilter;datefilter)
            {
            }
            column(mealcode;"CAT-Cafeteria Item Inventory"."Item No")
            {
            }
            column(desc;"CAT-Cafeteria Item Inventory"."Item Description")
            {
            }
            column(qty;"CAT-Cafeteria Item Inventory"."Quantity Sold")
            {
            }
            column(cashsales;"CAT-Cafeteria Item Inventory"."Cash Sales")
            {
            }
            column(creditsales;"CAT-Cafeteria Item Inventory"."Credit Sales")
            {
            }
            column(advancesales;"CAT-Cafeteria Item Inventory"."Advance Sales")
            {
            }
            column(creditEmp;creditEmp)
            {
            }
            column(qtyOnStore;"CAT-Cafeteria Item Inventory"."Quantity in Store")
            {
            }
            column(BonApettie;'************************ END ************************')
            {
            }
            column(double_Line;'==========================================================================')
            {
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
                "CAT-Cafeteria Item Inventory".CalcFields("CAT-Cafeteria Item Inventory"."Quantity Sold",
                "CAT-Cafeteria Item Inventory"."Cash Sales",
                "CAT-Cafeteria Item Inventory"."Credit Sales",
                "CAT-Cafeteria Item Inventory"."Advance Sales",
                "CAT-Cafeteria Item Inventory"."Quantity in Store");
                //"Cafeteria Item Inventory".CALCFIELDS("Cafeteria Receipts"."Customer Name");
                
                //"Cafeteria Item Inventory".CALCFIELDS("Cafeteria Receipts"."Employee Name");
                
                /*creditEmp:='';
                IF "Cafeteria Receipts"."Employee No"<>'' THEN
                creditEmp:="Cafeteria Receipts"."Employee No"+': '+"Employee Name";*/

            end;

            trigger OnPreDataItem()
            begin
                 "CAT-Cafeteria Item Inventory".SetFilter("CAT-Cafeteria Item Inventory"."Menu Date",'=%1',datefilter);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(datefilter;datefilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sale Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
          datefilter:=Today;
    end;

    trigger OnPreReport()
    begin
         if datefilter=0D then Error('Please specify the sale date.')
    end;

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
        datefilter: Date;
}

