#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99907 "Monthly Meal-Proc. Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Monthly Meal-Proc. Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable99901;UnknownTable99901)
        {
            DataItemTableView = sorting("Batch Date") order(ascending);
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Batch Date","Production  Area","Batch Serial","Date of Manufacture","Expiry Date";
            column(ReportForNavId_1000000009; 1000000009)
            {
            }
            column(BatchDate;"Meal-Proc. Batch Lines"."Batch Date")
            {
            }
            column(ItemCode;"Meal-Proc. Batch Lines"."Item Code")
            {
            }
            column(ProdArea;"Meal-Proc. Batch Lines"."Production  Area")
            {
            }
            column(reqQty;"Meal-Proc. Batch Lines"."Required QTY")
            {
            }
            column(UoM;"Meal-Proc. Batch Lines"."Requirered Unit of Measure")
            {
            }
            column(QTyKgs;"Meal-Proc. Batch Lines"."QTY in KGs")
            {
            }
            column(QTYTones;"Meal-Proc. Batch Lines"."QTY in Tones")
            {
            }
            column(ProdDesc;"Meal-Proc. Batch Lines"."Item Description")
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompPhone1;CompanyInformation."Phone No.")
            {
            }
            column(CompPhone2;CompanyInformation."Phone No. 2")
            {
            }
            column(CompEmail;CompanyInformation."E-Mail")
            {
            }
            column(CompPage;CompanyInformation."Home Page")
            {
            }
            column(CompPin;CompanyInformation."Company P.I.N")
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(CompRegNo;CompanyInformation."Registration No.")
            {
            }
            column(ParentDesc;"Meal-Proc. Batch Lines"."Item Description")
            {
            }
            column(BatchSerisl;"Meal-Proc. Batch Lines"."Batch Serial")
            {
            }
            column(ManDate;"Meal-Proc. Batch Lines"."Date of Manufacture")
            {
            }
            column(ExpDate;"Meal-Proc. Batch Lines"."Expiry Date")
            {
            }
            column(Monthz;Monthz)
            {
            }
            column(Users;UserId)
            {
            }
            column(ProdDate;Today)
            {
            }
            column(ProdTime;Time)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Monthz);
                if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=1 then Monthz:='JANUARY'
                else if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=2 then Monthz:='FEBRUARY'
                else if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=3 then Monthz:='MARCH'
                else if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=4 then Monthz:='APRIL'
                else if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=5 then Monthz:='MAY'
                else if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=6 then Monthz:='JUNE'
                else if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=7 then Monthz:='JULY'
                else if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=8 then Monthz:='AUGUST'
                else if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=9 then Monthz:='SEPTEMBER'
                else if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=10 then Monthz:='OCTOBER'
                else if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=11 then Monthz:='NOVEMBER'
                else if Date2dmy("Meal-Proc. Batch Lines"."Batch Date",2)=12 then Monthz:='DECEMBER';
                "Meal-Proc. Batch Lines".CalcFields("Meal-Proc. Batch Lines"."Item Description");
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

    trigger OnInitReport()
    begin
        if CompanyInformation.Get() then
          CompanyInformation.CalcFields(CompanyInformation.Picture);
        Clear(Gtoto);
        Clear(seq);
    end;

    var
        CompanyInformation: Record "Company Information";
        Gtoto: Decimal;
        seq: Integer;
        Item: Record Item;
        ItemUnitofMeasure: Record "Item Unit of Measure";
        SUOMQ: Decimal;
        SelUOMQ: Decimal;
        Item_Multiplier: Decimal;
        ProductionCustProdSource: Record UnknownRecord99902;
        Monthz: Code[20];
}

