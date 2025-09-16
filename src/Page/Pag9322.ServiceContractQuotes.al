#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9322 "Service Contract Quotes"
{
    ApplicationArea = Basic;
    Caption = 'Service Contract Quotes';
    CardPageID = "Service Contract Quote";
    Editable = false;
    PageType = List;
    SourceTable = "Service Contract Header";
    SourceTableView = where("Contract Type"=const(Quote));
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
            group("&Quote")
            {
                Caption = '&Quote';
                Image = Quote;
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
                                  "Service Contract Type"=filter(Quote);
                }
                separator(Action1102601024)
                {
                }
                action("&Filed Contract Quotes")
                {
                    ApplicationArea = Basic;
                    Caption = '&Filed Contract Quotes';
                    Image = Quote;
                    RunObject = Page "Filed Service Contract List";
                    RunPageLink = "Contract Type Relation"=field("Contract Type"),
                                  "Contract No. Relation"=field("Contract No.");
                    RunPageView = sorting("Contract Type Relation","Contract No. Relation","File Date","File Time")
                                  order(descending);
                }
            }
        }
        area(processing)
        {
            action("&Make Contract")
            {
                ApplicationArea = Basic;
                Caption = '&Make Contract';
                Image = MakeAgreement;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SignServContractDoc: Codeunit SignServContractDoc;
                begin
                    CurrPage.Update(true);
                    SignServContractDoc.SignContractQuote(Rec);
                end;
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
    }

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;
    end;
}

