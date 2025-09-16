#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51869 "Fuel-Trip Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Fuel-Trip Analysis.rdlc';

    dataset
    {
        dataitem("Company Information";"Company Information")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Log;comp.Picture)
            {
            }
            column(CompName;comp.Name)
            {
            }
            dataitem(UnknownTable61801;UnknownTable61801)
            {
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(Requisition_No;"FLT-Transport Requisition"."Transport Requisition No")
                {
                }
                column(Commencement;"FLT-Transport Requisition".Commencement)
                {
                }
                column(Destination;"FLT-Transport Requisition".Destination)
                {
                }
                column(V_Allocated;"FLT-Transport Requisition"."Vehicle Allocated")
                {
                }
                column(Driver;"FLT-Transport Requisition"."Driver Allocated")
                {
                }
                column(Requested_By;"FLT-Transport Requisition"."Requested By")
                {
                }
                column(Date;"FLT-Transport Requisition"."Date of Request")
                {
                }
                column(Allocated_By;"FLT-Transport Requisition"."Vehicle Allocated by")
                {
                }
                column(Vehicle_readings;"FLT-Transport Requisition"."Opening Odometer Reading")
                {
                }
                column(Remarks;"FLT-Transport Requisition".Comments)
                {
                }
                column(Trip_Date;"FLT-Transport Requisition"."Date of Trip")
                {
                }
                column(Trip_purposes;"FLT-Transport Requisition"."Purpose of Trip")
                {
                }
                column(Department;"FLT-Transport Requisition".Department)
                {
                }
                dataitem(UnknownTable61803;UnknownTable61803)
                {
                    column(ReportForNavId_1000000016; 1000000016)
                    {
                    }
                    column(Requisition_Nos;"FLT-Fuel & Maintenance Req."."Requisition No")
                    {
                    }
                    column(Reg_No;"FLT-Fuel & Maintenance Req."."Vehicle Reg No")
                    {
                    }
                    column(Fuel_Quantity;"FLT-Fuel & Maintenance Req."."Quantity of Fuel(Litres)")
                    {
                    }
                    column(Total_Fuel;"FLT-Fuel & Maintenance Req."."Total Price of Fuel")
                    {
                    }
                    column(Dates;"FLT-Fuel & Maintenance Req."."Request Date")
                    {
                    }
                    column(Fueling_date;"FLT-Fuel & Maintenance Req."."Date Taken for Fueling")
                    {
                    }
                    column(Departments;"FLT-Fuel & Maintenance Req.".Department)
                    {
                    }
                    column(Fuel_price;"FLT-Fuel & Maintenance Req."."Price/Litre")
                    {
                    }
                    column(Littles;"FLT-Fuel & Maintenance Req."."Litres of Oil")
                    {
                    }
                    column(Price;"FLT-Fuel & Maintenance Req."."Price/Litre")
                    {
                    }
                }
            }
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
        comp.Reset;
        if comp.FindFirst then begin
          comp.CalcFields(Picture);
        end;
    end;

    var
        comp: Record "Company Information";
}

