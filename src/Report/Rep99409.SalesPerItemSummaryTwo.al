#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99409 "Sales Per Item Summary Two"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Per Item Summary Two.rdlc';
    UsageCategory = Lists;

    dataset
    {
        dataitem(PosLines;"POS Sales Lines")
        {
            DataItemTableView = where(Posted=filter(true));
            RequestFilterFields = "Posting date";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(DocumentNo_PosLines;PosLines."Document No.")
            {
            }
            column(No_PosLines;PosLines."No.")
            {
            }
            column(Quantity_PosLines;PosLines.Quantity)
            {
            }
            column(Description_PosLines;PosLines.Description)
            {
            }
            column(UnitOfMeasure_PosLines;PosLines."Unit Of Measure")
            {
            }
            column(Price_PosLines;PosLines.Price)
            {
            }
            column(LineTotal_PosLines;PosLines."Line Total")
            {
            }
            column(Inventory_PosLines;PosLines.Inventory)
            {
            }
            column(ServingCategory_PosLines;PosLines."Serving Category")
            {
            }
            column(Postingdate_PosLines;Format(PosLines."Posting date"))
            {
            }
            column(Posted_PosLines;PosLines.Posted)
            {
            }
            column(CName;Info.Name)
            {
            }
            column(address;Info.Address)
            {
            }
            column(cphone;Info."Phone No.")
            {
            }
            column(logo;Info.Picture)
            {
            }
            column(email;Info."E-Mail")
            {
            }
            column(url;Info."Home Page")
            {
            }

            trigger OnAfterGetRecord()
            begin
                sheader.Reset();
                  sheader.SetRange("No.", "No.");
                  if sheader.Find('-') then begin
                      sheader.CalcFields("Total Amount");
                      ttamount := sheader."Total Amount";
                  end;
            end;

            trigger OnPreDataItem()
            begin
                Info.Get;
                Info.CalcFields(Picture);
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
        Info: Record "Company Information";
        sheader: Record "POS Sales Header";
        ttamount: Decimal;
}

