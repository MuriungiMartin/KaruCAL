#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51173 "HR Transport Allocations"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Transport Allocations.rdlc';

    dataset
    {
        dataitem(UnknownTable61657;UnknownTable61657)
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Transport Allocation No",Status;
            column(ReportForNavId_6666; 6666)
            {
            }
            column(CI_Name;CI.Name)
            {
                IncludeCaption = true;
            }
            column(CI_Address;CI.Address)
            {
                IncludeCaption = true;
            }
            column(CI_Address2;CI."Address 2" )
            {
                IncludeCaption = true;
            }
            column(CI_PhoneNo;CI."Phone No.")
            {
                IncludeCaption = true;
            }
            column(CI_Picture;CI.Picture)
            {
                IncludeCaption = true;
            }
            column(CI_City;CI.City)
            {
                IncludeCaption = true;
            }
            column(AssignedDriver_HRTransportAllocationsH;"HRM-Staff Transport Alloc."."Assigned Driver")
            {
                IncludeCaption = true;
            }
            column(DriverName_HRTransportAllocationsH;"HRM-Staff Transport Alloc."."Driver Name")
            {
                IncludeCaption = true;
            }
            column(DateofTrip_HRTransportAllocationsH;"HRM-Staff Transport Alloc."."Date of Trip")
            {
                IncludeCaption = true;
            }
            column(TransportAllocationNo_HRTransportAllocationsH;"HRM-Staff Transport Alloc."."Transport Allocation No")
            {
                IncludeCaption = true;
            }
            column(VehicleRegNumber_HRTransportAllocationsH;"HRM-Staff Transport Alloc."."Vehicle Reg Number")
            {
                IncludeCaption = true;
            }
            column(Destinations_HRTransportAllocationsH;"HRM-Staff Transport Alloc."."Destination(s)")
            {
                IncludeCaption = true;
            }
            dataitem(UnknownTable61256;UnknownTable61256)
            {
                DataItemLink = "Allocation No"=field("Transport Allocation No");
                DataItemTableView = sorting("Allocation No","Requisition No") order(ascending);
                column(ReportForNavId_2575; 2575)
                {
                }
                column(EmployeeNo_HRTransportAllocations;"HRM-Transport Allocations"."Employee No")
                {
                    IncludeCaption = true;
                }
                column(PassengersFullNames_HRTransportAllocations;"HRM-Transport Allocations"."Passenger/s Full Name/s")
                {
                    IncludeCaption = true;
                }
                column(Dept_HRTransportAllocations;"HRM-Transport Allocations".Dept)
                {
                    IncludeCaption = true;
                }
                column(From_HRTransportAllocations;"HRM-Transport Allocations".From)
                {
                    IncludeCaption = true;
                }
                column(No;No)
                {
                    IncludeCaption = false;
                }

                trigger OnAfterGetRecord()
                begin
                                Int:=Int+1;
                end;

                trigger OnPreDataItem()
                begin
                                Int:=0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                No:=No+1;
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
                       CI.Get();
                       CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        Int: Integer;
        HR_Transport_RequisitionsCaptionLbl: label 'HR Transport Requisitions';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        TRANSPORT_REQUESTCaptionLbl: label 'TRANSPORT REQUEST';
        Travelling_Staff_DetailsCaptionLbl: label 'Travelling Staff Details';
        No: Integer;
}

