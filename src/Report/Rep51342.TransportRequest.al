#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51342 "Transport Request"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Transport Request.rdlc';

    dataset
    {
        dataitem(UnknownTable61801;UnknownTable61801)
        {
            RequestFilterFields = "Transport Requisition No","Vehicle Allocated","Driver Allocated";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(ReqNo;"FLT-Transport Requisition"."Transport Requisition No")
            {
            }
            column(Commencement;"FLT-Transport Requisition".Commencement)
            {
            }
            column(Destination;"FLT-Transport Requisition".Destination)
            {
            }
            column(Vehicle;"FLT-Transport Requisition"."Vehicle Allocated")
            {
            }
            column(Driver;"FLT-Transport Requisition"."Driver Allocated")
            {
            }
            column(ReqBy;"FLT-Transport Requisition"."Requested By")
            {
            }
            column(ReqDate;"FLT-Transport Requisition"."Date of Request")
            {
            }
            column(AllocBy;"FLT-Transport Requisition"."Vehicle Allocated by")
            {
            }
            column(OpenningOdoMeterReading;"FLT-Transport Requisition"."Opening Odometer Reading")
            {
            }
            column(Status;"FLT-Transport Requisition".Status)
            {
            }
            column(DateOfTrip;"FLT-Transport Requisition"."Date of Trip")
            {
            }
            column(Purpose;"FLT-Transport Requisition"."Purpose of Trip")
            {
            }
            column(DiverName;"FLT-Transport Requisition"."Driver Name")
            {
            }
            column(RespCent;"FLT-Transport Requisition"."Responsibility Center")
            {
            }
            column(Position;"FLT-Transport Requisition".Position)
            {
            }
            column(Names;"FLT-Transport Requisition".Name)
            {
            }
            column(ClossingODO;"FLT-Transport Requisition"."Clossing ODO")
            {
            }
            column(NatureofTrip;"FLT-Transport Requisition"."Nature of Trip")
            {
            }
            column(Group;"FLT-Transport Requisition".Group)
            {
            }
            column(clubs;"FLT-Transport Requisition"."Club/Societies")
            {
            }
            column(PtronNo;"FLT-Transport Requisition"."Emp No")
            {
            }
            column(PatronName;"FLT-Transport Requisition"."Employee Name")
            {
            }
            column(Log;comp.Picture)
            {
            }
            column(CompName;comp.Name)
            {
            }
            column(Models;"FLT-Transport Requisition".Model)
            {
            }
            column(Makes;"FLT-Transport Requisition".Make)
            {
            }
            column(TransportAvailNot;"FLT-Transport Requisition"."Transport Available/Not Av.")
            {
            }
            column(CluSocieties;"FLT-Transport Requisition"."Club/Societies")
            {
            }
            column(ReturnConfirmeBy;"FLT-Transport Requisition"."Return Confirmed By")
            {
            }
            column(VehicleCapacity;"FLT-Transport Requisition"."Vehicle Capacity")
            {
            }
            column(CostPerKilometer;"FLT-Transport Requisition"."Cost Per Kilometer")
            {
            }
            column(ReturnDate;"FLT-Transport Requisition"."Transport Return Date")
            {
            }
            column(Mileagetravelled;"FLT-Transport Requisition"."Total Mileage Travelled")
            {
            }
            column(MileageAfterTrip;"FLT-Transport Requisition"."Milleage after Trip")
            {
            }
            column(MileageBeforeTrip;"FLT-Transport Requisition"."Mileage Before Trip")
            {
            }
            column(TotalCoset;"FLT-Transport Requisition"."Total Cost")
            {
            }
            column(FuelUnitCost;"FLT-Transport Requisition"."Fuel Unit Cost")
            {
            }
            column(ApprovedRate;"FLT-Transport Requisition"."Approved Rate")
            {
            }
            column(EstimateMileage;"FLT-Transport Requisition"."Estimated Mileage")
            {
            }
            column(Days;"FLT-Transport Requisition"."No of Days Requested")
            {
            }
            column(TimeOut;"FLT-Transport Requisition"."Time out")
            {
            }
            column(TimeIn;"FLT-Transport Requisition"."Time In")
            {
            }
            column(TimeRequested;"FLT-Transport Requisition"."Time Requested")
            {
            }
            column(Department;"FLT-Transport Requisition".Department)
            {
            }
            column(DriverName;"FLT-Transport Requisition"."Driver Name")
            {
            }
            column(TimeOftrip;"FLT-Transport Requisition"."Time of trip")
            {
            }
            column(NoOfPassangers;"FLT-Transport Requisition"."No Of Passangers")
            {
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

