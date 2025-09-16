#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5980 "Maintenance Visit - Planning"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Maintenance Visit - Planning.rdlc';
    Caption = 'Maintenance Visit - Planning';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            DataItemTableView = sorting("Responsibility Center","Service Zone Code",Status,"Contract Group Code") where("Contract Type"=const(Contract),Status=const(Signed));
            RequestFilterFields = "Responsibility Center","Service Zone Code","Contract Group Code","Contract No.";
            column(ReportForNavId_9952; 9952)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(ServContractHdrTbCaptFltr;TableCaption + ': ' + ServContractFilter)
            {
            }
            column(ServContractLineTCaptFltr;"Service Contract Line".TableCaption + ': ' + ServContractLineFilter)
            {
            }
            column(EmptyStrCtrl1;'.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .')
            {
            }
            column(ServContractFilter;ServContractFilter)
            {
            }
            column(ServContractLineFilter;ServContractLineFilter)
            {
            }
            column(RespCntr_ServContractHdr;"Responsibility Center")
            {
                IncludeCaption = true;
            }
            column(CurrReportPAGENOCaption;CurrReportPAGENOCaptionLbl)
            {
            }
            column(MaintenanceVisitPlanningCaption;MaintenanceVisitPlanningCaptionLbl)
            {
            }
            column(ServiceZoneCodeCaption;ServiceZoneCodeCaptionLbl)
            {
            }
            column(GroupCodeCaption;GroupCodeCaptionLbl)
            {
            }
            column(CustShiptoNameCaption;CustShiptoNameCaptionLbl)
            {
            }
            column(NextPlannedCaption;NextPlannedCaptionLbl)
            {
            }
            column(LastActualCaption;LastActualCaptionLbl)
            {
            }
            column(LastPlannedCaption;LastPlannedCaptionLbl)
            {
            }
            column(ServiceDatesCaption;ServiceDatesCaptionLbl)
            {
            }
            dataitem("Service Contract Line";"Service Contract Line")
            {
                DataItemLink = "Contract Type"=field("Contract Type"),"Contract No."=field("Contract No.");
                DataItemTableView = sorting("Contract Type","Contract No.","Line No.");
                RequestFilterFields = "Next Planned Service Date";
                column(ReportForNavId_6062; 6062)
                {
                }
                column(ServZnCd_ServContractHdr;"Service Contract Header"."Service Zone Code")
                {
                }
                column(ContrGrpCd_ServContractHdr;"Service Contract Header"."Contract Group Code")
                {
                }
                column(ContrNo_ServContractLine;"Contract No.")
                {
                    IncludeCaption = true;
                }
                column(CustNo_ServContractLine;"Customer No.")
                {
                    IncludeCaption = true;
                }
                column(ShiptoCd_ServContractLine;"Ship-to Code")
                {
                    IncludeCaption = true;
                }
                column(CustShiptoName;CustShiptoName)
                {
                }
                column(ServPerd_ServContractLine;"Service Period")
                {
                    IncludeCaption = true;
                }
                column(NxtPlServDt_ServContractLine;Format("Next Planned Service Date"))
                {
                }
                column(LstServDt_ServContractLine;Format("Last Service Date"))
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                CustShiptoName := '';

                if "Ship-to Code" = '' then begin
                  if Cust.Get("Customer No.") then
                    CustShiptoName := Cust.Name;
                end else
                  if ShiptoAddr.Get("Customer No.","Ship-to Code") then
                    CustShiptoName := ShiptoAddr.Name;
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
        ServContractFilter := "Service Contract Header".GetFilters;
        ServContractLineFilter := "Service Contract Line".GetFilters;
    end;

    var
        Cust: Record Customer;
        ShiptoAddr: Record "Ship-to Address";
        CustShiptoName: Text[50];
        ServContractFilter: Text;
        ServContractLineFilter: Text;
        CurrReportPAGENOCaptionLbl: label 'Page';
        MaintenanceVisitPlanningCaptionLbl: label 'Maintenance Visit - Planning';
        ServiceZoneCodeCaptionLbl: label 'Service Zone Code';
        GroupCodeCaptionLbl: label 'Group Code';
        CustShiptoNameCaptionLbl: label 'Customer Name';
        NextPlannedCaptionLbl: label 'Next Planned';
        LastActualCaptionLbl: label 'Last Actual';
        LastPlannedCaptionLbl: label 'Last Planned';
        ServiceDatesCaptionLbl: label 'Service Dates';
}

