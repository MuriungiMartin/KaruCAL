#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99413 "Restaurants PrintOut Copy"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Restaurants PrintOut Copy.rdlc';

    dataset
    {
        dataitem(POSHeader;"POS Sales Header")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No_POSHeader;POSHeader."No.")
            {
            }
            column(PostingDescription_POSHeader;POSHeader."Posting Description")
            {
            }
            column(TotalAmount_POSHeader;POSHeader."Total Amount")
            {
            }
            column(Postingdate_POSHeader;Format(POSHeader."Posting date"))
            {
            }
            column(Cashier_POSHeader;POSHeader.Cashier)
            {
            }
            column(CustomerType_POSHeader;POSHeader."Customer Type")
            {
            }
            column(BankAccount_POSHeader;POSHeader."Bank Account")
            {
            }
            column(IncomeAccount_POSHeader;POSHeader."Income Account")
            {
            }
            column(AmountPaid_POSHeader;POSHeader."Amount Paid")
            {
            }
            column(Balance_POSHeader;POSHeader.Balance)
            {
            }
            column(NoSeries_POSHeader;POSHeader."No. Series")
            {
            }
            column(Posted_POSHeader;POSHeader.Posted)
            {
            }
            column(CurrentDateTime_POSHeader;Format(POSHeader."Current Date Time"))
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
            column(UserName;UserName)
            {
            }
            dataitem(POSLines;"POS Sales Lines")
            {
                DataItemLink = "Document No."=field("No.");
                column(ReportForNavId_1000000020; 1000000020)
                {
                }
                column(DocumentNo_POSLines;POSLines."Document No.")
                {
                }
                column(No_POSLines;POSLines."No.")
                {
                }
                column(Quantity_POSLines;POSLines.Quantity)
                {
                }
                column(Description_POSLines;POSLines.Description)
                {
                }
                column(UnitOfMeasure_POSLines;POSLines."Unit Of Measure")
                {
                }
                column(Price_POSLines;POSLines.Price)
                {
                }
                column(LineTotal_POSLines;POSLines."Line Total")
                {
                }
                column(Inventory_POSLines;POSLines.Inventory)
                {
                }
                column(ServingCategory_POSLines;POSLines."Serving Category")
                {
                }
                column(Postingdate_POSLines;POSLines."Posting date")
                {
                }
                column(Posted_POSLines;POSLines.Posted)
                {
                }
                column(ttamount;ttamount)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                sheader.Reset();
                  sheader.SetRange("No.", "No.");
                  if sheader.Find('-') then begin
                      sheader.CalcFields("Total Amount");
                      ttamount := sheader."Total Amount";
                  end;

                Clear(UserName);
                Users.Reset;
                Users.SetRange(Users."User Name",UserId);
                if Users.Find('-') then begin
                    if Users."Full Name"<>'' then UserName:=Users."Full Name" else
                      UserName:=Users."User Name";
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
        Users: Record User;
        UserName: Text[130];
}

