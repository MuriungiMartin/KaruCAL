#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1129 "Cost Allocations"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cost Allocations.rdlc';
    Caption = 'Cost Allocations';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Cost Allocation Source";"Cost Allocation Source")
        {
            RequestFilterFields = ID,Level,"Valid From","Valid To",Variant;
            column(ReportForNavId_1662; 1662)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column("Filter";Text000 + GetFilters)
            {
            }
            column(Level_CostAllocSource;Level)
            {
                IncludeCaption = true;
            }
            column(ValidFrom_CostAllocSource;Format("Valid From"))
            {
            }
            column(ValidTo_CostAllocSource;Format("Valid To"))
            {
            }
            column(SourceID_CostAllocSource;ID)
            {
                IncludeCaption = true;
            }
            column(CostTypeRange_CostAllocSource;"Cost Type Range")
            {
                IncludeCaption = true;
            }
            column(CrToCostType_CostAllocSource;"Credit to Cost Type")
            {
                IncludeCaption = true;
            }
            column(TotalShare_CostAllocSource;"Total Share")
            {
                IncludeCaption = true;
            }
            column(Blocked_CostAllocSource;Format(Blocked))
            {
            }
            column(LastDateModified_CostAllocSource;"Last Date Modified")
            {
                IncludeCaption = true;
            }
            column(CostObjCode_CostAllocSource;"Cost Object Code")
            {
                IncludeCaption = true;
            }
            column(CostCenterCode_CostAllocSource;"Cost Center Code")
            {
                IncludeCaption = true;
            }
            column(AllocationsCaption;AllocationsCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(CostAllocationSourceValidFromCaption;CostAllocationSourceValidFromCaptionLbl)
            {
            }
            column(SourceCaption;SourceCaptionLbl)
            {
            }
            column(BlockedCaption;BlockedCaptionLbl)
            {
            }
            dataitem("Cost Allocation Target";"Cost Allocation Target")
            {
                DataItemLink = ID=field(ID);
                DataItemTableView = sorting(ID,"Line No.");
                RequestFilterFields = "Target Cost Type","Target Cost Center","Target Cost Object","Allocation Target Type","Share Updated on";
                column(ReportForNavId_9203; 9203)
                {
                }
                column(TargetCostType_CostAllocTarget;"Target Cost Type")
                {
                    IncludeCaption = true;
                }
                column(TargetCostCenter_CostAllocTarget;"Target Cost Center")
                {
                    IncludeCaption = true;
                }
                column(TargetCostObject_CostAllocTarget;"Target Cost Object")
                {
                    IncludeCaption = true;
                }
                column(AllocType_CostAllocTarget;"Allocation Target Type")
                {
                    IncludeCaption = true;
                }
                column(PercentperShare_CostAllocTarget;"Percent per Share")
                {
                    IncludeCaption = true;
                }
                column(AmtperShare_CostAllocTarget;"Amount per Share")
                {
                    IncludeCaption = true;
                }
                column(Base_CostAllocTarget;Base)
                {
                    IncludeCaption = true;
                }
                column(CostCenterFilter_CostAllocTarget;"Cost Center Filter")
                {
                    IncludeCaption = true;
                }
                column(CostObjFilter_CostAllocTarget;"Cost Object Filter")
                {
                    IncludeCaption = true;
                }
                column(DateFilterCode_CostAllocTarget;"Date Filter Code")
                {
                    IncludeCaption = true;
                }
                column(GroupFilter_CostAllocTarget;"Group Filter")
                {
                    IncludeCaption = true;
                }
                column(Share_CostAllocTarget;Share)
                {
                    IncludeCaption = true;
                }
            }

            trigger OnAfterGetRecord()
            var
                CostAllocationTarget: Record "Cost Allocation Target";
            begin
                if PrintOnlyIfDetail then begin
                  CostAllocationTarget.SetView("Cost Allocation Target".GetView);
                  CostAllocationTarget.SetRange(ID,ID);

                  if CostAllocationTarget.IsEmpty then
                    CurrReport.Skip;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SkipalocSourceswithoutaloctgt;PrintOnlyIfDetail)
                {
                    ApplicationArea = Basic;
                    Caption = 'Skip allocation sources without allocation targets in the filter.';
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

    var
        Text000: label 'Filter: ';
        PrintOnlyIfDetail: Boolean;
        AllocationsCaptionLbl: label 'Cost Allocations';
        PageCaptionLbl: label 'Page';
        CostAllocationSourceValidFromCaptionLbl: label 'Valid From';
        SourceCaptionLbl: label 'Source';
        BlockedCaptionLbl: label 'Blocked';


    procedure InitializeRequest(var CostAllocationSource: Record "Cost Allocation Source";var CostAllocationTarget: Record "Cost Allocation Target";PrintOnlyIfDetailNew: Boolean)
    begin
        "Cost Allocation Source".CopyFilters(CostAllocationSource);
        "Cost Allocation Target".CopyFilters(CostAllocationTarget);
        PrintOnlyIfDetail := PrintOnlyIfDetailNew;
    end;
}

