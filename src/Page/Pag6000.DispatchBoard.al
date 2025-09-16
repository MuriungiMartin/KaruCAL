#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6000 "Dispatch Board"
{
    ApplicationArea = Basic;
    Caption = 'Dispatch Board';
    DataCaptionFields = Status;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Service Header";
    SourceTableView = sorting(Status,"Response Date","Response Time",Priority);
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ResourceFilter;ResourceFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Filter';
                    ToolTip = 'Specifies the filter that displays an overview of documents with service item lines that a certain resource is allocated to.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Res.Reset;
                        if Page.RunModal(0,Res) = Action::LookupOK then begin
                          Text := Res."No.";
                          exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetResourceFilter;
                        ResourceFilterOnAfterValidate;
                    end;
                }
                field(ResourceGroupFilter;ResourceGroupFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Group Filter';
                    ToolTip = 'Specifies the filter that displays an overview of documents with service item lines that a certain resource group is allocated to.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ResourceGroup.Reset;
                        if Page.RunModal(0,ResourceGroup) = Action::LookupOK then begin
                          Text := ResourceGroup."No.";
                          exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetResourceGroupFilter;
                        ResourceGroupFilterOnAfterVali;
                    end;
                }
                field(RespDateFilter;RespDateFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Response Date Filter';
                    ToolTip = 'Specifies the filter that displays an overview of documents with the specified value in the Response Date field.';

                    trigger OnValidate()
                    begin
                        SetRespDateFilter;
                        RespDateFilterOnAfterValidate;
                    end;
                }
                field(AllocationFilter;AllocationFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Allocation Filter';
                    OptionCaption = ' ,No or Partial Allocation,Full Allocation,Reallocation Needed';
                    ToolTip = 'Specifies the filter that displays the overview of documents from their allocation analysis point of view.';

                    trigger OnValidate()
                    begin
                        SetAllocFilter;
                        AllocationFilterOnAfterValidat;
                    end;
                }
                field(DocFilter;DocFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Filter';
                    OptionCaption = 'Order,Quote,All';
                    ToolTip = 'Specifies the filter that displays the overview of the documents of the specified type.';

                    trigger OnValidate()
                    begin
                        SetDocFilter;
                        DocFilterOnAfterValidate;
                    end;
                }
                field(ServOrderFilter;ServOrderFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. Filter';
                    ToolTip = 'Specifies the filter that is used to see the specified document.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ServHeader.Reset;
                        SetDocFilter2(ServHeader);
                        if Page.RunModal(0,ServHeader) = Action::LookupOK then begin
                          Text := ServHeader."No.";
                          exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetServOrderFilter;
                        ServOrderFilterOnAfterValidate;
                    end;
                }
                field(StatusFilter;StatusFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Status Filter';
                    OptionCaption = ' ,Pending,In Process,Finished,On Hold';
                    ToolTip = 'Specifies the filter that displays an overview of documents with a certain value in the Status field.';

                    trigger OnValidate()
                    begin
                        SetStatusFilter;
                        StatusFilterOnAfterValidate;
                    end;
                }
                field(CustomFilter;CustomFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Filter';
                    ToolTip = 'Specifies the filter that displays an overview of documents with a certain value in the Customer No. field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Cust.Reset;
                        if Page.RunModal(0,Cust) = Action::LookupOK then begin
                          Text := Cust."No.";
                          exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetCustFilter;
                        CustomFilterOnAfterValidate;
                    end;
                }
                field(ContractFilter;ContractFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Filter';
                    ToolTip = 'Specifies all billable prices for the job task.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ServiceContract.Reset;
                        ServiceContract.SetRange("Contract Type",ServiceContract."contract type"::Contract);
                        if Page.RunModal(0,ServiceContract) = Action::LookupOK then begin
                          Text := ServiceContract."Contract No.";
                          exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetContractFilter;
                        ContractFilterOnAfterValidate;
                    end;
                }
                field(ZoneFilter;ZoneFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Zone Filter';
                    ToolTip = 'Specifies the filter that displays an overview of documents with a certain value in the Service Zone Code field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ServiceZones.Reset;
                        if Page.RunModal(0,ServiceZones) = Action::LookupOK then begin
                          Text := ServiceZones.Code;
                          exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetZoneFilter;
                        ZoneFilterOnAfterValidate;
                    end;
                }
            }
            repeater(Control1)
            {
                Editable = false;
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated date when work on the order should start, that is, when the service order status changes from Pending, to In Process.';
                }
                field("Response Time";"Response Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated time when work on the order starts, that is, when the service order status changes from Pending, to In Process.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the priority of the service order.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the service document on the line.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service document you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a short description of the service document, such as Order 2001.';
                    Visible = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service order status, which reflects the repair or maintenance status of all service items on the service order.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who owns the items in the service document.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom the items on the document will be shipped.';
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the contract associated with the order.';
                }
                field("Service Zone Code";"Service Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service zone code of the customer''s ship-to address in the service order.';
                }
                field("No. of Allocations";"No. of Allocations")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of resource allocations to service items in this order.';
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service order was created.';
                }
                field("Order Time";"Order Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when the service order was created.';
                }
                field("Reallocation Needed";"Reallocation Needed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you must reallocate resources to at least one service item in this service order.';
                }
            }
            group(Control94)
            {
                field(Description2;Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Order Description';
                    Editable = false;
                    ToolTip = 'Specifies a short description of the service document, such as Order 2001.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Dispatch Board")
            {
                Caption = '&Dispatch Board';
                Image = ServiceMan;
                action("&Show Document")
                {
                    ApplicationArea = Basic;
                    Caption = '&Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        PageManagement.PageRunModal(Rec);
                    end;
                }
            }
            group("Pla&nning")
            {
                Caption = 'Pla&nning';
                Image = Planning;
                action("Resource &Allocations")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource &Allocations';
                    Image = ResourcePlanning;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Resource Allocations";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "Document No."=field("No.");
                    RunPageView = sorting(Status,"Document Type","Document No.","Service Item Line No.","Allocation Date","Starting Time",Posted)
                                  where(Status=filter(<>Canceled));
                }
                separator(Action14)
                {
                }
                action("Demand Overview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Demand Overview';
                    Image = Forecast;

                    trigger OnAction()
                    var
                        DemandOverview: Page "Demand Overview";
                    begin
                        DemandOverview.SetCalculationParameter(true);
                        DemandOverview.Initialize(0D,4,'','','');
                        DemandOverview.RunModal;
                    end;
                }
            }
        }
        area(processing)
        {
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("Print &Dispatch Board")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print &Dispatch Board';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    begin
                        Report.Run(Report::"Dispatch Board",true,true,Rec);
                    end;
                }
                action("Print Service &Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Service &Order';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    begin
                        Clear(ServHeader);
                        ServHeader.SetRange("Document Type","Document Type");
                        ServHeader.SetRange("No.","No.");
                        Report.Run(Report::"Service Order",true,true,ServHeader);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UserMgt.GetServiceFilter <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center",UserMgt.GetServiceFilter);
          FilterGroup(0);
        end;
        SetAllFilters;

        if IsEmpty then begin
          ServOrderFilter := '';
          SetServOrderFilter;
        end;
    end;

    var
        ServiceZones: Record "Service Zone";
        Cust: Record Customer;
        Res: Record Resource;
        ResourceGroup: Record "Resource Group";
        ServHeader: Record "Service Header";
        ServiceContract: Record "Service Contract Header";
        UserMgt: Codeunit "User Setup Management";
        DocFilter: Option "Order",Quote,All;
        StatusFilter: Option " ",Pending,"In Process",Finished,"On Hold";
        RespDateFilter: Text;
        ServOrderFilter: Text;
        CustomFilter: Text;
        ZoneFilter: Text;
        ContractFilter: Text;
        ResourceFilter: Text;
        ResourceGroupFilter: Text;
        AllocationFilter: Option " ","No or Partial Allocation","Full Allocation","Reallocation Needed";


    procedure SetAllFilters()
    begin
        SetDocFilter;
        SetStatusFilter;
        SetRespDateFilter;
        SetServOrderFilter;
        SetCustFilter;
        SetZoneFilter;
        SetContractFilter;
        SetResourceFilter;
        SetResourceGroupFilter;
        SetAllocFilter;
    end;


    procedure SetDocFilter()
    begin
        FilterGroup(2);
        SetDocFilter2(Rec);
        FilterGroup(0);
    end;


    procedure SetDocFilter2(var ServHeader: Record "Service Header")
    begin
        with ServHeader do begin
          FilterGroup(2);
          case DocFilter of
            Docfilter::Order:
              SetRange("Document Type","document type"::Order);
            Docfilter::Quote:
              SetRange("Document Type","document type"::Quote);
            Docfilter::All:
              SetFilter("Document Type",'%1|%2',"document type"::Order,"document type"::Quote);
          end;
          FilterGroup(0);
        end;
    end;


    procedure SetStatusFilter()
    begin
        FilterGroup(2);
        case StatusFilter of
          Statusfilter::" ":
            SetRange(Status);
          Statusfilter::Pending:
            SetRange(Status,Status::Pending);
          Statusfilter::"In Process":
            SetRange(Status,Status::"In Process");
          Statusfilter::Finished:
            SetRange(Status,Status::Finished);
          Statusfilter::"On Hold":
            SetRange(Status,Status::"On Hold");
        end;
        FilterGroup(0);
    end;


    procedure SetRespDateFilter()
    begin
        FilterGroup(2);
        SetFilter("Response Date",RespDateFilter);
        RespDateFilter := GetFilter("Response Date");
        FilterGroup(0);
    end;


    procedure SetServOrderFilter()
    begin
        FilterGroup(2);
        SetFilter("No.",ServOrderFilter);
        ServOrderFilter := GetFilter("No.");
        FilterGroup(0);
    end;


    procedure SetCustFilter()
    begin
        FilterGroup(2);
        SetFilter("Customer No.",CustomFilter);
        CustomFilter := GetFilter("Customer No.");
        FilterGroup(0);
    end;


    procedure SetZoneFilter()
    begin
        FilterGroup(2);
        SetFilter("Service Zone Code",ZoneFilter);
        ZoneFilter := GetFilter("Service Zone Code");
        FilterGroup(0);
    end;


    procedure SetContractFilter()
    begin
        FilterGroup(2);
        SetFilter("Contract No.",ContractFilter);
        ContractFilter := GetFilter("Contract No.");
        FilterGroup(0);
    end;


    procedure SetResourceFilter()
    begin
        FilterGroup(2);
        if ResourceFilter <> '' then begin
          SetFilter("No. of Allocations",'>0');
          SetFilter("Resource Filter",ResourceFilter);
          ResourceFilter := GetFilter("Resource Filter");
        end else begin
          if ResourceGroupFilter = '' then
            SetRange("No. of Allocations");
          SetRange("Resource Filter");
        end;
        FilterGroup(0);
    end;


    procedure SetResourceGroupFilter()
    begin
        FilterGroup(2);
        if ResourceGroupFilter <> '' then begin
          SetFilter("No. of Allocations",'>0');
          SetFilter("Resource Group Filter",ResourceGroupFilter);
          ResourceGroupFilter := GetFilter("Resource Group Filter");
        end else begin
          if ResourceFilter = '' then
            SetRange("No. of Allocations");
          SetRange("Resource Group Filter");
        end;
        FilterGroup(0);
    end;


    procedure SetAllocFilter()
    begin
        FilterGroup(2);
        case AllocationFilter of
          Allocationfilter::" ":
            begin
              SetRange("No. of Unallocated Items");
              SetRange("Reallocation Needed");
            end;
          Allocationfilter::"No or Partial Allocation":
            begin
              SetFilter("No. of Unallocated Items",'>0');
              SetRange("Reallocation Needed",false);
            end;
          Allocationfilter::"Full Allocation":
            begin
              SetRange("No. of Unallocated Items",0);
              SetRange("Reallocation Needed",false);
            end;
          Allocationfilter::"Reallocation Needed":
            begin
              SetRange("No. of Unallocated Items");
              SetRange("Reallocation Needed",true);
            end;
        end;
        FilterGroup(0);
    end;

    local procedure RespDateFilterOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure ServOrderFilterOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure StatusFilterOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure ZoneFilterOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure CustomFilterOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure ContractFilterOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure ResourceFilterOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure DocFilterOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure AllocationFilterOnAfterValidat()
    begin
        CurrPage.Update(false);
    end;

    local procedure ResourceGroupFilterOnAfterVali()
    begin
        CurrPage.Update(false);
    end;
}

