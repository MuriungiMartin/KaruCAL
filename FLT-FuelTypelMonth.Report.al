#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 55503 "FLT-Fuel Typel/Month"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FLT-Fuel TypelMonth.rdlc';

    dataset
    {
        dataitem(UnknownTable55501;UnknownTable55501)
        {
            RequestFilterFields = "Vehicle Registration","Fuelling Date","Fuelling Done By (Employee)";
            column(ReportForNavId_1000000001; 1000000001)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Address;CompanyInformation.Address+' ,'+CompanyInformation."Address 2"+' ,'+CompanyInformation.City)
            {
            }
            column(conts;CompanyInformation."Phone No."+' '+CompanyInformation."Phone No. 2")
            {
            }
            column(mails;CompanyInformation."E-Mail"+' '+CompanyInformation."Home Page")
            {
            }
            column(Logo;CompanyInformation.Picture)
            {
            }
            column(ReqDate;CreateDatetime("FLT-Fuel Req. Details"."Fuelling Date","FLT-Fuel Req. Details"."Fuelling Time"))
            {
            }
            column(EmpName;HRMEmployeeC."First Name"+' '+HRMEmployeeC."Middle Name"+' '+HRMEmployeeC."Last Name")
            {
            }
            column(LineNo;"FLT-Fuel Req. Details"."Line No.")
            {
            }
            column(Registration;FLTVehicleHeader."Registration No.")
            {
            }
            column(VehicleDetails;"FLT-Fuel Req. Details"."Vehicle Details")
            {
            }
            column(FuelType;"FLT-Fuel Req. Details"."Fuel Type")
            {
            }
            column(CCRating;"FLT-Fuel Req. Details"."CC Rating")
            {
            }
            column(Quantity;"FLT-Fuel Req. Details"."Quantity (Litres)")
            {
            }
            column(UnitPrice;"FLT-Fuel Req. Details"."Unit Price")
            {
            }
            column(LineAmount;"FLT-Fuel Req. Details".Amount)
            {
            }
            column(filtersz;filtersz)
            {
            }
            column(currMonth;currMonth)
            {
            }
            column(currYear;currYear)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "FLT-Fuel Req. Details"."Fuelling Date"=0D then  CurrReport.Skip;
                Clear(FLTVehicleHeader);
                Clear(userset);
                Clear(HRMEmployeeC);
                FLTVehicleHeader.Reset;
                FLTVehicleHeader.SetRange("No.","FLT-Fuel Req. Details"."Vehicle Registration");
                if FLTVehicleHeader.Find('-') then;
                // userset.RESET;
                // userset.SETRANGE("Staff No","FLT-Fuel Req. Details"."Fuelling Done By (Employee)"
                // IF userset.FIND('-') THEN BEGIN
                HRMEmployeeC.Reset;
                HRMEmployeeC.SetRange("No.","FLT-Fuel Req. Details"."Fuelling Done By (Employee)");
                if HRMEmployeeC.Find('-') then begin
                  end;
                 // END;currYear
                 Clear(currMonth);
                 Clear(currYear);
                 currYear:=Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",3);
                 if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=1 then currMonth:='JANUARY'
                 else if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=2 then currMonth:='FEBRUARY'
                 else if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=2 then currMonth:='MARCH'
                 else if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=2 then currMonth:='APRIL'
                 else if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=2 then currMonth:='MAY'
                 else if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=2 then currMonth:='JUNE'
                 else if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=2 then currMonth:='JULY'
                 else if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=2 then currMonth:='AUGUST'
                 else if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=2 then currMonth:='SEPTEMBER'
                 else if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=2 then currMonth:='OCTOBER'
                 else if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=2 then currMonth:='NOVEMBER'
                 else if Date2dmy("FLT-Fuel Req. Details"."Fuelling Date",2)=2 then currMonth:='DECEMBER';
            end;

            trigger OnPreDataItem()
            begin
                Clear(filtersz);
                if "FLT-Fuel Req. Details".GetFilters<>'' then filtersz:="FLT-Fuel Req. Details".GetFilters;
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
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        FLTVehicleHeader: Record UnknownRecord61816;
        HRMEmployeeC: Record UnknownRecord61188;
        HRMEmployeeC2: Record UnknownRecord61188;
        userset: Record "User Setup";
        filtersz: Text[250];
        currMonth: Code[20];
        currYear: Integer;
}

