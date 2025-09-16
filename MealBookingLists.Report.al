#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70011 "Meal Booking Lists"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Meal Booking Lists.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Cust;UnknownTable61778)
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Booking Date",Venue,Department;
            column(ReportForNavId_1000000000; 1000000000)
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
            column(CustNo;Cust."Booking Id")
            {
            }
            column(CustName;Cust."Department Name")
            {
            }
            column(PhoneNo;Cust."Booking Date")
            {
            }
            column(Balance;Cust."Meeting Name")
            {
            }
            column(CreditLimit;Cust.Venue)
            {
            }
            column(Variances;Cust."Total Cost")
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

            trigger OnAfterGetRecord()
            begin
                seq:=seq+1;
                /*IntMonth:=DATE2DMY(SalesHeader."Posting Date",2);
                IF IntMonth<>0 THEN BEGIN
                  IF IntMonth=1 THEN BEGIN
                    MonthName:='JAN';
                    END ELSE IF IntMonth=2 THEN BEGIN
                      MonthName:='FEB';
                      END  ELSE IF IntMonth=3 THEN BEGIN
                        MonthName:='MAR';
                      END  ELSE IF IntMonth=4 THEN BEGIN
                        MonthName:='APRIL';
                      END  ELSE IF IntMonth=5 THEN BEGIN
                        MonthName:='MAY';
                      END  ELSE IF IntMonth=6 THEN BEGIN
                        MonthName:='JUNE';
                      END  ELSE IF IntMonth=7 THEN BEGIN
                        MonthName:='JULY';
                      END  ELSE IF IntMonth=8 THEN BEGIN
                        MonthName:='AUG';
                      END  ELSE IF IntMonth=9 THEN BEGIN
                        MonthName:='SEPT';
                      END  ELSE IF IntMonth=10 THEN BEGIN
                        MonthName:='OCT';
                      END  ELSE IF IntMonth=11 THEN BEGIN
                        MonthName:='NOV';
                      END  ELSE IF IntMonth=12 THEN BEGIN
                        MonthName:='DEC';
                      END
                  END;*/

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
        if info.Get() then begin
          info.CalcFields(Picture);
          end;

        Clear(seq);
    end;

    var
        info: Record "Company Information";
        route: Code[20];
        MonthName: Code[20];
        IntMonth: Integer;
        StartDate: Date;
        EndDate: Date;
        seq: Integer;
}

