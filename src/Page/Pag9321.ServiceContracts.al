#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9321 "Service Contracts"
{
    ApplicationArea = Basic;
    Caption = 'Service Contracts';
    CardPageID = "Service Contract";
    Editable = false;
    PageType = List;
    SourceTable = "Service Contract Header";
    SourceTableView = where("Contract Type"=const(Contract));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service contract or service contract quote.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the service contract or contract quote.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service contract.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who owns the service items in the service contract/contract quote.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer in the service contract.';
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code for the customer.';
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer name.';
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the service contract.';
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service contract expires.';
                }
                field("Change Status";"Change Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if a service contract or contract quote is locked or open for changes.';
                    Visible = false;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment terms code for the customer in the contract.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency used to calculate the amounts in the documents related to this contract.';
                    Visible = false;
                }
                field("First Service Date";"First Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the first expected service for the service items in the contract.';
                    Visible = false;
                }
                field("Service Order Type";"Service Order Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service order type assigned to service orders linked to this contract.';
                    Visible = false;
                }
                field("Invoice Period";"Invoice Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the invoice period for the service contract.';
                    Visible = false;
                }
                field("Next Price Update Date";"Next Price Update Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the next date you want contract prices to be updated.';
                    Visible = false;
                }
                field("Last Price Update Date";"Last Price Update Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date you last updated the contract prices.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1902018507;"Customer Statistics FactBox")
            {
                SubPageLink = "No."=field("Bill-to Customer No."),
                              "Date Filter"=field("Date Filter");
                Visible = true;
            }
            part(Control1900316107;"Customer Details FactBox")
            {
                SubPageLink = "No."=field("Customer No."),
                              "Date Filter"=field("Date Filter");
                Visible = true;
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Contract")
            {
                Caption = '&Contract';
                Image = Agreement;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                separator(Action1102601003)
                {
                    Caption = '';
                }
                action("Service Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger E&ntries';
                    Image = ServiceLedger;
                    RunObject = Page "Service Ledger Entries";
                    RunPageLink = "Service Contract No."=field("Contract No.");
                    RunPageView = sorting("Service Contract No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("&Warranty Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Warranty Ledger Entries';
                    Image = WarrantyLedger;
                    RunObject = Page "Warranty Ledger Entries";
                    RunPageLink = "Service Contract No."=field("Contract No.");
                    RunPageView = sorting("Service Contract No.","Posting Date","Document No.");
                }
                separator(Action1102601006)
                {
                }
                action("Service Dis&counts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Dis&counts';
                    Image = Discount;
                    RunObject = Page "Contract/Service Discounts";
                    RunPageLink = "Contract Type"=field("Contract Type"),
                                  "Contract No."=field("Contract No.");
                }
                action("Service &Hours")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service &Hours';
                    Image = ServiceHours;
                    RunObject = Page "Service Hours";
                    RunPageLink = "Service Contract No."=field("Contract No."),
                                  "Service Contract Type"=filter(Contract);
                }
                separator(Action1102601009)
                {
                    Caption = '';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name"=const("Service Contract"),
                                  "Table Subtype"=field("Contract Type"),
                                  "No."=field("Contract No."),
                                  "Table Line No."=const(0);
                }
                separator(Action1102601011)
                {
                    Caption = '';
                }
                group(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Action1102601013)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Contract Statistics";
                        RunPageLink = "Contract Type"=const(Contract),
                                      "Contract No."=field("Contract No.");
                        ShortCutKey = 'F7';
                    }
                    action("Tr&endscape")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Tr&endscape';
                        Image = Trendscape;
                        RunObject = Page "Contract Trendscape";
                        RunPageLink = "Contract Type"=const(Contract),
                                      "Contract No."=field("Contract No.");
                    }
                }
                separator(Action1102601016)
                {
                }
                action("Filed Contracts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Filed Contracts';
                    Image = Agreement;
                    RunObject = Page "Filed Service Contract List";
                    RunPageLink = "Contract Type Relation"=field("Contract Type"),
                                  "Contract No. Relation"=field("Contract No.");
                    RunPageView = sorting("Contract Type Relation","Contract No. Relation","File Date","File Time")
                                  order(descending);
                }
                group("Ser&vice Overview")
                {
                    Caption = 'Ser&vice Overview';
                    Image = Tools;
                    action("Service Orders")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Orders';
                        Image = Document;
                        RunObject = Page "Service List";
                        RunPageLink = "Document Type"=const(Order),
                                      "Contract No."=field("Contract No.");
                        RunPageView = sorting("Contract No.");
                    }
                    action("Posted Service Invoices")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posted Service Invoices';
                        Image = PostedServiceOrder;
                        RunObject = Page "Service Document Registers";
                        RunPageLink = "Source Document No."=field("Contract No.");
                        RunPageView = sorting("Source Document Type","Source Document No.","Destination Document Type","Destination Document No.")
                                      where("Source Document Type"=const(Contract),
                                            "Destination Document Type"=const("Posted Invoice"));
                    }
                }
                action("C&hange Log")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&hange Log';
                    Image = ChangeLog;
                    RunObject = Page "Contract Change Log";
                    RunPageLink = "Contract No."=field("Contract No.");
                    RunPageView = sorting("Contract No.")
                                  order(descending);
                }
                action("&Gain/Loss Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Gain/Loss Entries';
                    Image = GainLossEntries;
                    RunObject = Page "Contract Gain/Loss Entries";
                    RunPageLink = "Contract No."=field("Contract No.");
                    RunPageView = sorting("Contract No.","Change Date")
                                  order(descending);
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Si&gn Contract")
                {
                    ApplicationArea = Basic;
                    Caption = 'Si&gn Contract';
                    Image = Signature;

                    trigger OnAction()
                    var
                        SignServContractDoc: Codeunit SignServContractDoc;
                    begin
                        CurrPage.Update;
                        SignServContractDoc.SignContract(Rec);
                        CurrPage.Update;
                    end;
                }
                separator(Action1102601032)
                {
                    Caption = '';
                }
                action("&Lock Contract")
                {
                    ApplicationArea = Basic;
                    Caption = '&Lock Contract';
                    Image = Lock;

                    trigger OnAction()
                    var
                        LockOpenServContract: Codeunit "Lock-OpenServContract";
                    begin
                        CurrPage.Update;
                        LockOpenServContract.LockServContract(Rec);
                        CurrPage.Update;
                    end;
                }
                action("&Open Contract")
                {
                    ApplicationArea = Basic;
                    Caption = '&Open Contract';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        LockOpenServContract: Codeunit "Lock-OpenServContract";
                    begin
                        CurrPage.Update;
                        LockOpenServContract.OpenServContract(Rec);
                        CurrPage.Update;
                    end;
                }
            }
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    DocPrint.PrintServiceContract(Rec);
                end;
            }
        }
        area(reporting)
        {
            action("Contract, Service Order Test")
            {
                ApplicationArea = Basic;
                Caption = 'Contract, Service Order Test';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Contr. Serv. Orders - Test";
            }
            action("Maintenance Visit - Planning")
            {
                ApplicationArea = Basic;
                Caption = 'Maintenance Visit - Planning';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Maintenance Visit - Planning";
            }
            action("Service Contract Details")
            {
                ApplicationArea = Basic;
                Caption = 'Service Contract Details';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Service Contract-Detail";
            }
            action("Service Contract Profit")
            {
                ApplicationArea = Basic;
                Caption = 'Service Contract Profit';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Service Profit (Contracts)";
            }
            action("Contract Invoice Test")
            {
                ApplicationArea = Basic;
                Caption = 'Contract Invoice Test';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Contract Invoicing";
                ToolTip = 'Specifies billable profits for the job task that are related to items.';
            }
            action("Service Contract-Customer")
            {
                ApplicationArea = Basic;
                Caption = 'Service Contract-Customer';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Service Contract - Customer";
            }
            action("Service Contract-Salesperson")
            {
                ApplicationArea = Basic;
                Caption = 'Service Contract-Salesperson';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Serv. Contract - Salesperson";
            }
            action("Contract Price Update - Test")
            {
                ApplicationArea = Basic;
                Caption = 'Contract Price Update - Test';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Contract Price Update - Test";
            }
            action("Service Items Out of Warranty")
            {
                ApplicationArea = Basic;
                Caption = 'Service Items Out of Warranty';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Service Items Out of Warranty";
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;
    end;
}

