#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5919 "Service Mgt. Setup"
{
    ApplicationArea = Basic;
    Caption = 'Service Mgt. Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Service Mgt. Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("First Warning Within (Hours)";"First Warning Within (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of hours before the response time that the program sends the first warning about the response time approaching for a service order.';
                }
                field("Send First Warning To";"Send First Warning To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the email address that will be used to send the first warning about the response time for a service order that is approaching.';
                }
                field("Second Warning Within (Hours)";"Second Warning Within (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of hours before the response time that the program sends the second warning about the response time approaching for a service order.';
                }
                field("Send Second Warning To";"Send Second Warning To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the email address that will be used to send the second warning about the response time for a service order that is approaching.';
                }
                field("Third Warning Within (Hours)";"Third Warning Within (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of hours before the response time that the program sends the third warning about the response time approaching for a service order.';
                }
                field("Send Third Warning To";"Send Third Warning To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the email address that will be used to send the third warning about the response time for a service order that is approaching.';
                }
                field("Serv. Job Responsibility Code";"Serv. Job Responsibility Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the job responsibility designated for the service management application area.';
                }
                field("Next Service Calc. Method";"Next Service Calc. Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how you want the program to recalculate the next planned service date for service items in service contracts.';
                }
                field("Service Order Starting Fee";"Service Order Starting Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for a service order starting fee.';
                }
                field("Shipment on Invoice";"Shipment on Invoice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that if you post a manually-created invoice, this will create a posted shipment, in addition to a posted invoice.';
                }
                field("One Service Item Line/Order";"One Service Item Line/Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you can enter only one service item line for each service order.';
                }
                field("Link Service to Service Item";"Link Service to Service Item")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that service lines for resources and items must be linked to a service item line.';
                }
                field("Resource Skills Option";"Resource Skills Option")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how to identify resource skills in your company when you allocate resources to service items.';
                }
                field("Service Zones Option";"Service Zones Option")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how to identify service zones in your company when you allocate resources to service items.';
                }
                field("Fault Reporting Level";"Fault Reporting Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the level of fault reporting that your company uses in the Service Management application area.';
                }
                field("Base Calendar Code";"Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = true;
                    ToolTip = 'Specifies the code for the base calendar you want to assign to your service department.';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        TestField("Base Calendar Code");
                        CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."source type"::Service,'','',"Base Calendar Code");
                    end;
                }
                field("Copy Comments Order to Invoice";"Copy Comments Order to Invoice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether to copy comments from service orders to service invoices.';
                }
                field("Copy Comments Order to Shpt.";"Copy Comments Order to Shpt.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether to copy comments from service orders to shipments.';
                }
                field("Logo Position on Documents";"Logo Position on Documents")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the position of your company logo on your business letters and documents, such as service invoices and service shipments.';
                }
                field("Copy Time Sheet to Order";"Copy Time Sheet to Order")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Mandatory Fields")
            {
                Caption = 'Mandatory Fields';
                field("Service Order Type Mandatory";"Service Order Type Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a service order must have a service order type assigned before the order can be posted.';
                }
                field("Service Order Start Mandatory";"Service Order Start Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the Starting Date and Starting Time fields on a service order must be filled in before you can post the service order.';
                }
                field("Service Order Finish Mandatory";"Service Order Finish Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the Finishing Date and Finishing Time fields on a service order must be filled in before you can post the service order.';
                }
                field("Contract Rsp. Time Mandatory";"Contract Rsp. Time Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the Response Time (Hours) field must be filled on service contract lines before you can convert a quote to a contract.';
                }
                field("Unit of Measure Mandatory";"Unit of Measure Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the Description field must be filled in before you can post the line.';
                }
                field("Fault Reason Code Mandatory";"Fault Reason Code Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the Fault Reason Code field must be filled in before you can post the service order.';
                }
                field("Work Type Code Mandatory";"Work Type Code Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the Work Type Code field with type Resource must be filled in before you can post the line.';
                }
                field("Salesperson Mandatory";"Salesperson Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you must fill in the Salesperson Code field on the headers of service orders, invoices, credit memos, and service contracts.';
                }
            }
            group(Defaults)
            {
                Caption = 'Defaults';
                field("Default Response Time (Hours)";"Default Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default response time, in hours, required to start service, either on a service order or on a service item line.';
                }
                field("Warranty Disc. % (Parts)";"Warranty Disc. % (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default warranty discount percentage on spare parts.';
                }
                field("Warranty Disc. % (Labor)";"Warranty Disc. % (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default warranty discount percentage on labor.';
                }
                field("Default Warranty Duration";"Default Warranty Duration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default duration for warranty discounts on service items.';
                }
            }
            group(Contracts)
            {
                Caption = 'Contracts';
                field("Contract Serv. Ord.  Max. Days";"Contract Serv. Ord.  Max. Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum number of days you can use as the date range each time you run the Create Contract Service Orders batch job.';
                }
                field("Use Contract Cancel Reason";"Use Contract Cancel Reason")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a reason code is entered when you cancel a service contract.';
                }
                field("Register Contract Changes";"Register Contract Changes")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you want the program to log changes to service contracts in the Contract Change Log table.';
                }
                field("Contract Inv. Line Text Code";"Contract Inv. Line Text Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the standard text entered in the Description field on the line in a contract invoice.';
                }
                field("Contract Line Inv. Text Code";"Contract Line Inv. Text Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the standard text entered in the Description field on the line in a contract invoice.';
                }
                field("Contract Inv. Period Text Code";"Contract Inv. Period Text Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the standard text entered in the Description field on the line in a contract invoice.';
                }
                field("Contract Credit Line Text Code";"Contract Credit Line Text Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the standard text that entered in the Description field on the line in a contract credit memo.';
                }
                field("Contract Value Calc. Method";"Contract Value Calc. Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method to use for calculating the default contract value of service items when they are created.';
                }
                field("Contract Value %";"Contract Value %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage used to calculate the default contract value of a service item when it is created.';
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Service Item Nos.";"Service Item Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to service items.';
                }
                field("Service Quote Nos.";"Service Quote Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series for the service quotes.';
                }
                field("Service Order Nos.";"Service Order Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to service orders.';
                }
                field("Service Invoice Nos.";"Service Invoice Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to invoices.';
                }
                field("Posted Service Invoice Nos.";"Posted Service Invoice Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to service invoices when they are posted.';
                }
                field("Service Credit Memo Nos.";"Service Credit Memo Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used to assign numbers to service credit memos.';
                }
                field("Posted Serv. Credit Memo Nos.";"Posted Serv. Credit Memo Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to service credit memos when they are posted.';
                }
                field("Posted Service Shipment Nos.";"Posted Service Shipment Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to shipments when they are posted.';
                }
                field("Loaner Nos.";"Loaner Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to loaners.';
                }
                field("Troubleshooting Nos.";"Troubleshooting Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to troubleshooting guidelines.';
                }
                field("Service Contract Nos.";"Service Contract Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to service contracts.';
                }
                field("Contract Template Nos.";"Contract Template Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to contract templates.';
                }
                field("Contract Invoice Nos.";"Contract Invoice Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to invoices created for service contracts.';
                }
                field("Contract Credit Memo Nos.";"Contract Credit Memo Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to credit memos for service contracts.';
                }
                field("Prepaid Posting Document Nos.";"Prepaid Posting Document Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that will be used to assign a document number to the journal lines.';
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
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;

    var
        CustomizedCalEntry: Record "Customized Calendar Entry";
        CalendarMgmt: Codeunit "Calendar Management";
}

