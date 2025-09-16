#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65583 "Sales Person/Month/Trans T."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales PersonMonthTrans T..rdlc';

    dataset
    {
        dataitem(SalesHeader;"Sales Shipment Header")
        {
            DataItemTableView = where("Cash Sale Order"=filter(true),"User ID"=filter(<>'WANJALA'));
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Sell-to Customer No.","Posting Date","No.","User ID";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(OderDate;SalesHeader."Posting Date")
            {
            }
            column(TransType;TransType)
            {
            }
            column(seq;seq)
            {
            }
            column(StartDate;StartDate)
            {
            }
            column(EndDate;EndDate)
            {
            }
            column(MonthName;MonthName)
            {
            }
            column(docNo;SalesHeader."No.")
            {
            }
            column(CustNo;SalesHeader."Sell-to Customer No.")
            {
            }
            column(CustName;SalesHeader."Bill-to Name")
            {
            }
            column(SalesPerson;SalesHeader."Salesperson Code")
            {
            }
            column(PostingDate;SalesHeader."Posting Date")
            {
            }
            column(PostingDesc;SalesHeader."Posting Description")
            {
            }
            column(SalesPersonCode;SalesHeader."Salesperson Code")
            {
            }
            column(InvAmount;SalesHeader."Document Amount")
            {
            }
            column(Users;SalesHeader."User ID")
            {
            }
            column(CompAddress;info.Address)
            {
            }
            column(CompAddress1;info."Address 2")
            {
            }
            column(CompPhonenO;info."Phone No.")
            {
            }
            column(CompPhoneNo2;info."Phone No. 2")
            {
            }
            column(CompPic;info.Picture)
            {
            }
            column(CompEmail1;info."E-Mail")
            {
            }
            column(CompHome;info."Home Page")
            {
            }
            column(filters;SalesHeader.GetFilters)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(MonthName);
                Clear(IntMonth);
                Clear(TransType);
                if SalesHeader."Credit Sale"=true then TransType:='CREDIT' else TransType:='CASH';
                seq:=seq+1;
                IntMonth:=Date2dmy(SalesHeader."Posting Date",2);
                if IntMonth<>0 then begin
                  if IntMonth=1 then begin
                    MonthName:='JAN';
                    end else if IntMonth=2 then begin
                      MonthName:='FEB';
                      end  else if IntMonth=3 then begin
                        MonthName:='MAR';
                      end  else if IntMonth=4 then begin
                        MonthName:='APRIL';
                      end  else if IntMonth=5 then begin
                        MonthName:='MAY';
                      end  else if IntMonth=6 then begin
                        MonthName:='JUNE';
                      end  else if IntMonth=7 then begin
                        MonthName:='JULY';
                      end  else if IntMonth=8 then begin
                        MonthName:='AUG';
                      end  else if IntMonth=9 then begin
                        MonthName:='SEPT';
                      end  else if IntMonth=10 then begin
                        MonthName:='OCT';
                      end  else if IntMonth=11 then begin
                        MonthName:='NOV';
                      end  else if IntMonth=12 then begin
                        MonthName:='DEC';
                      end
                  end;
            end;

            trigger OnPreDataItem()
            begin
                SalesHeader.SetRange("Posting Date",StartDate,EndDate);
                SalesHeader.SetCurrentkey("Posting Date");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(DateFilters)
                {
                    Caption = 'Date Range';
                    field(StartDate;StartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Start Date:';
                    }
                    field(EndDate;EndDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'End Date:';
                    }
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
        if info.Get() then begin
         // info.CALCFIELDS(Picture);
          end;

        Clear(seq);
    end;

    trigger OnPreReport()
    begin
        if ((StartDate=0D) or (EndDate=0D)) then Error('Specify date range');
    end;

    var
        info: Record "Company Information";
        route: Code[20];
        cust: Record Customer;
        MonthName: Code[20];
        IntMonth: Integer;
        StartDate: Date;
        EndDate: Date;
        seq: Integer;
        TransType: Code[20];
}

