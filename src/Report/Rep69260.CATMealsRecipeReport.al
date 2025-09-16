#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69260 "CAT-Meals Recipe Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CAT-Meals Recipe Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61768;UnknownTable61768)
        {
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000004; 1000000004)
            {
            }
            column(pic;info.Picture)
            {
            }
            column(seq;seq)
            {
            }
            column(comp;'KARATINA UNIVERSITY')
            {
            }
            column(tittle;'MEAL RECIPE')
            {
            }
            column(CompName;info.Name)
            {
            }
            column(CompAddress;info.Address)
            {
            }
            column(CompPhone;info."Phone No.")
            {
            }
            column(CompMail;info."E-Mail")
            {
            }
            column(CompHomePage;info."Home Page")
            {
            }
            column(MealCode;"CAT-Meals Setup".Code)
            {
            }
            column(Desc;"CAT-Meals Setup".Discription)
            {
            }
            column(bonapettie;'***************************************** BON APETTIE *****************************************')
            {
            }
            column(RecipeCost;"CAT-Meals Setup"."Recipe Cost")
            {
            }
            column(RecipePrice;"CAT-Meals Setup"."Recipe Price")
            {
            }
            dataitem(UnknownTable69260;UnknownTable69260)
            {
                DataItemLink = "Meal Code"=field(Code);
                column(ReportForNavId_1; 1)
                {
                }
                column(Type;"Meals Recipe"."Resource Type")
                {
                }
                column(Resource;"Meals Recipe".Resource)
                {
                }
                column(Name;"Meals Recipe"."Resource Name")
                {
                }
                column(Qty;"Meals Recipe".Quantity)
                {
                }
                column(UnitCost;"Meals Recipe"."Unit Cost")
                {
                }
                column(Markup;"Meals Recipe"."Markup %")
                {
                }
                column(UnitPrice;"Meals Recipe"."Unit Price")
                {
                }
                column(FinalCost;"Meals Recipe"."Final Cost")
                {
                }
                column(FinalPrice;"Meals Recipe"."Final Price")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                 seq:=seq+1;
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
          DateFilter:=Today;
    end;

    trigger OnPreReport()
    begin
          info.Reset;
          if info.Find('-') then begin
          info.CalcFields(info.Picture);
          end;
          Clear(seq);
    end;

    var
        DateFilter: Date;
        CafeSections: Option " ",Students,Staff;
        info: Record "Company Information";
        seq: Integer;
}

