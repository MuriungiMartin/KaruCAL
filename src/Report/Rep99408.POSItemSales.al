#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99408 "POS Item Sales"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/POS Item Sales.rdlc';
    UsageCategory = Lists;

    dataset
    {
        dataitem(posItem;"POS Items")
        {
            RequestFilterFields = "Date Filter";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No_posItem;posItem."No.")
            {
            }
            column(Description_posItem;posItem.Description)
            {
            }
            column(UnitOfmeasure_posItem;posItem."Unit Of measure")
            {
            }
            column(Inventory_posItem;posItem.Inventory)
            {
            }
            column(DateFilter_posItem;posItem."Date Filter")
            {
            }
            column(SalesAmount_posItem;posItem."Sales Amount")
            {
            }
            column(SoldUnits_posItem;posItem."Sold Units")
            {
            }
            column(Active_posItem;posItem.Active)
            {
            }
            column(CName;info.Name)
            {
            }
            column(address;info.Address)
            {
            }
            column(cphone;info."Phone No.")
            {
            }
            column(logo;info.Picture)
            {
            }
            column(email;info."E-Mail")
            {
            }
            column(url;info."Home Page")
            {
            }
            column(StatrtDate;Format(startdate))
            {
            }
            column(endDate;Format(endDate))
            {
            }
            column(sunits;sunits)
            {
            }
            column(samount;samount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                itm.Reset();
                  itm.SetRange("No.", posItem."No.");
                  itm.SetFilter("Date Filter", '%1..%2', startdate, endDate);
                  if itm.Find('-') then begin
                      itm.CalcFields("Sales Amount", "Sold Units");
                      sunits := itm."Sold Units";
                      samount := itm."Sales Amount";
                  end;
            end;

            trigger OnPreDataItem()
            begin
                info.Get;
                info.CalcFields(Picture);
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

    trigger OnPreReport()
    begin
        startdate := posItem.GetRangeMin("Date Filter");
        if posItem.GetRangemax("Date Filter") = 0D then
          endDate := posItem.GetRangeMin("Date Filter") else
          endDate := posItem.GetRangemax("Date Filter");
    end;

    var
        info: Record "Company Information";
        itm: Record "POS Items";
        startdate: Date;
        endDate: Date;
        sunits: Integer;
        samount: Integer;
}

