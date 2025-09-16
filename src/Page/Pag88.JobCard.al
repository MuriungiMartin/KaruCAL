#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 88 "Job Card"
{
    Caption = 'Job Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Prices';
    RefreshOnActivate = true;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number for the job. You can use one of the following methods to fill in the number:';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies a short description of the job.';
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the number of the customer that the job should be billed to.';

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No.";"Bill-to Contact No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the contact that the invoice will be sent to.';
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the Customer, which you assigned to the current job, in the Customer No. field. field.';
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies the address of the Customer, which you assigned to the current job, in the Customer No. field. field.';
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies the additional address of the Customer, which you assigned to the current job, in the Customer No. field. field.';
                }
                field("Bill-to City";"Bill-to City")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies the City of the Customer, which you assigned to the current job, in the Customer No. field. field.';
                }
                field("Bill-to County";"Bill-to County")
                {
                    ApplicationArea = Jobs;
                    Caption = 'State / ZIP Code';
                    ToolTip = 'Specifies the state or ZIP code of the customer that is assigned to the job.';
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies the ZIP Code of the Customer, which you assigned to the current job, in the Customer No. field. field.';
                }
                field("Bill-to Country/Region Code";"Bill-to Country/Region Code")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies the country/region code of the Customer, which you assigned to the current job, in the Customer No. field.';
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies the name of the contact person that you entered in the Contact No. field.';
                }
                field("Search Description";"Search Description")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies the additional name for the job. The field is used for searching purposes.';
                }
                field("Person Responsible";"Person Responsible")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the person responsible for the job. You can select a name from the list of resources available in the Resource List window. The name is copied from the No. field in the Resource table. You can choose the field to see a list of resources.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the blocking status for actions related to the job.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies when the job card was last modified.';
                }
                field("Project Manager";"Project Manager")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the person assigned as the manager for this job.';
                    Visible = JobSimplificationAvailable;
                }
            }
            part(JobTaskLines;"Job Task Lines Subform")
            {
                ApplicationArea = Jobs;
                Caption = 'Tasks';
                SubPageLink = "Job No."=field("No.");
                SubPageView = sorting("Job Task No.")
                              order(ascending);
            }
            group(Posting)
            {
                Caption = 'Posting';
                field(Status;Status)
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies a status for the current job. You can change the status for the job as it progresses. Final calculations can be made on completed jobs.';
                }
                field("Job Posting Group";"Job Posting Group")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies a job posting group code to a job. To see the available codes, choose the field.';
                }
                field("WIP Method";"WIP Method")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies the name of the work in process (WIP) calculation method that is associated with a job.';
                }
                field("WIP Posting Method";"WIP Posting Method")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies whether WIP Posting Method is per job or per job ledger entry. When you select Per Job, Microsoft Dynamics NAV uses total WIP costs and sales to calculate WIP. When you select Per Job Ledger Entry, Microsoft Dynamics NAV uses the accumulated values for WIP costs and sales.';
                }
                field("Allow Schedule/Contract Lines";"Allow Schedule/Contract Lines")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Allow Budget/Billable Lines';
                    Importance = Additional;
                    ToolTip = 'Specifies if you can add planning lines of type Both Budget and Billable to the job.';
                }
                field("Apply Usage Link";"Apply Usage Link")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies whether usage entries, from the job journal or purchase line, for example, are linked to job planning lines. Select this check box if you want to be able to track the quantities and amounts of the remaining work needed to complete a job and to create a relationship between demand planning, usage, and sales. On a job card, you can select this check box if there are no existing job planning lines that include type Budget that have been posted. The usage link only applies to job planning lines that include type Budget.';
                }
                field("% Completed";PercentCompleted)
                {
                    ApplicationArea = Jobs;
                    Caption = '% Completed';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the percentage of the job''s estimated resource usage that has been posted as used.';
                }
                field("% Invoiced";PercentInvoiced)
                {
                    ApplicationArea = Jobs;
                    Caption = '% Invoiced';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the percentage of the job''s invoice value that has been posted as invoiced.';
                }
                field("% of Overdue Planning Lines";PercentOverdue)
                {
                    ApplicationArea = Jobs;
                    Caption = '% of Overdue Planning Lines';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the percentage of the job''s planning lines where the planned delivery date has been exceeded.';
                }
            }
            group(Duration)
            {
                Caption = 'Duration';
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date on which the job actually starts.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date on which the job is expected to be completed.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date on which you set up the job.';
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    Editable = CurrencyCodeEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code for a job. By default, the currency code is empty. If you enter a foreign currency code, it results in the job being planned and invoiced in that currency.';

                    trigger OnValidate()
                    begin
                        CurrencyCheck;
                    end;
                }
                field("Invoice Currency Code";"Invoice Currency Code")
                {
                    ApplicationArea = Suite;
                    Editable = InvoiceCurrencyCodeEditable;
                    ToolTip = 'Specifies the currency code you want to apply when creating invoices for a job. By default, the invoice currency code for a job is based on what currency code is defined on the customer card.';

                    trigger OnValidate()
                    begin
                        CurrencyCheck;
                    end;
                }
                field("Exch. Calculation (Cost)";"Exch. Calculation (Cost)")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how job cost values should be calculated if you change the Currency Date field on a planning line manually, if you change the exchange rate in the Currency Code field on a Job Planning Line, or if you run the Change Job Planning Line Dates batch job -- this depends if you have set up a job in a foreign currency by entering a code in the Currency Code field.';
                }
                field("Exch. Calculation (Price)";"Exch. Calculation (Price)")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how job sales price values should be calculated if you change the Currency Date field on a planning line manually, if you change the exchange rate in the Currency Code field on a Job Planning Line, or if you run the Change Job Planning Line Dates batch job -- this depends if you have set up a job in a foreign currency by entering a code in the Currency Code field. The options are:';
                }
            }
            group("WIP and Recognition")
            {
                Caption = 'WIP and Recognition';
                group("To Post")
                {
                    Caption = 'To Post';
                    field("WIP Posting Date";"WIP Posting Date")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the posting date that was entered when the Job Calculate WIP batch job was last run.';
                    }
                    field("Total WIP Sales Amount";"Total WIP Sales Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the total WIP Sales amount that was last calculated for the job. The WIP Sales Amount for the job is the value WIP Sales Job WIP Entries less the value of the Recognized Sales Job WIP Entries. For jobs with WIP Methods of Cost Value or Cost of Sales, the WIP Sales Amount is normally 0.';
                    }
                    field("Applied Sales G/L Amount";"Applied Sales G/L Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the sum of all applied sales that is related to the selected job in the general ledger.';
                        Visible = false;
                    }
                    field("Total WIP Cost Amount";"Total WIP Cost Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the total WIP cost amount that was last calculated for the job. The WIP Cost Amount for the job is the value WIP Cost Job WIP Entries less the value of the Recognized Cost Job WIP Entries. For jobs with WIP Methods of Sales Value or Percentage of Completion, the WIP Cost Amount is normally 0.';
                    }
                    field("Applied Costs G/L Amount";"Applied Costs G/L Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the sum of all applied costs that is based on to the selected job in the general ledger.';
                        Visible = false;
                    }
                    field("Recog. Sales Amount";"Recog. Sales Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the recognized sales amount that was last calculated for the job. The Recog. Sales Amount for the job is the sum of the Recognized Sales Job WIP Entries.';
                    }
                    field("Recog. Costs Amount";"Recog. Costs Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the Recognized Cost amount that was last calculated for the job. The Recognized Cost Amount for the job is the sum of the Recognized Cost Job WIP Entries.';
                    }
                    field("Recog. Profit Amount";CalcRecognizedProfitAmount)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Recog. Profit Amount';
                        ToolTip = 'Specifies the recognized profit amount for the job.';
                    }
                    field("Recog. Profit %";CalcRecognizedProfitPercentage)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Recog. Profit %';
                        ToolTip = 'Specifies the recognized profit percentage for the job.';
                    }
                    field("Acc. WIP Costs Amount";CalcAccWIPCostsAmount)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Acc. WIP Costs Amount';
                        ToolTip = 'Specifies the total WIP costs for the job.';
                        Visible = false;
                    }
                    field("Acc. WIP Sales Amount";CalcAccWIPSalesAmount)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Acc. WIP Sales Amount';
                        ToolTip = 'Specifies the total WIP sales for the job.';
                        Visible = false;
                    }
                    field("Calc. Recog. Sales Amount";"Calc. Recog. Sales Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the sum of the recognized sales amount that is associated with job tasks.';
                        Visible = false;
                    }
                    field("Calc. Recog. Costs Amount";"Calc. Recog. Costs Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the sum of the recognized costs amount that is associated with job tasks.';
                        Visible = false;
                    }
                }
                group(Posted)
                {
                    Caption = 'Posted';
                    field("WIP G/L Posting Date";"WIP G/L Posting Date")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the posting date that was entered when the Job Post WIP to general ledger batch job was last run.';
                    }
                    field("Total WIP Sales G/L Amount";"Total WIP Sales G/L Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the total WIP Sales amount that was last posted to the general ledger for the job. The WIP Sales Amount for the job is the value WIP Sales Job WIP G/L Entries less the value of the Recognized Sales Job WIP G/L Entries. For jobs with WIP Methods of Cost Value or Cost of Sales, the WIP Sales Amount is normally 0.';
                    }
                    field("Total WIP Cost G/L Amount";"Total WIP Cost G/L Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the total WIP Cost amount that was last posted to the G/L for the job. The WIP Cost Amount for the job is the value WIP Cost Job WIP G/L Entries less the value of the Recognized Cost Job WIP G/L Entries. For jobs with WIP Methods of Sales Value or Percentage of Completion, the WIP Cost Amount is normally 0.';
                    }
                    field("Recog. Sales G/L Amount";"Recog. Sales G/L Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the total Recognized Sales amount that was last posted to the general ledger for the job. The Recognized Sales G/L amount for the job is the sum of the Recognized Sales Job WIP G/L Entries.';
                    }
                    field("Recog. Costs G/L Amount";"Recog. Costs G/L Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the total Recognized Cost amount that was last posted to the general ledger for the job. The Recognized Cost G/L amount for the job is the sum of the Recognized Cost Job WIP G/L Entries.';
                    }
                    field("Recog. Profit G/L Amount";CalcRecognizedProfitGLAmount)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Recog. Profit G/L Amount';
                        ToolTip = 'Specifies the total recognized profit G/L amount for this job.';
                    }
                    field("Recog. Profit G/L %";CalcRecognProfitGLPercentage)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Recog. Profit G/L %';
                        ToolTip = 'Specifies the recognized profit G/L percentage for this job.';
                    }
                    field("Calc. Recog. Sales G/L Amount";"Calc. Recog. Sales G/L Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the sum of the recognized sales general ledger amount that is associated with job tasks.';
                        Visible = false;
                    }
                    field("Calc. Recog. Costs G/L Amount";"Calc. Recog. Costs G/L Amount")
                    {
                        ApplicationArea = Jobs;
                        ToolTip = 'Specifies the sum of the recognized costs general ledger amount that is associated with job tasks.';
                        Visible = false;
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1902018507;"Customer Statistics FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No."=field("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1902136407;"Job No. of Prices FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No."=field("No."),
                              "Resource Filter"=field("Resource Filter"),
                              "Posting Date Filter"=field("Posting Date Filter"),
                              "Resource Gr. Filter"=field("Resource Gr. Filter"),
                              "Planning Date Filter"=field("Planning Date Filter");
                Visible = true;
            }
            part(Control1905650007;"Job WIP/Recognition FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No."=field("No."),
                              "Resource Filter"=field("Resource Filter"),
                              "Posting Date Filter"=field("Posting Date Filter"),
                              "Resource Gr. Filter"=field("Resource Gr. Filter"),
                              "Planning Date Filter"=field("Planning Date Filter");
                Visible = false;
            }
            part(Control44;"Job Cost Factbox")
            {
                ApplicationArea = Jobs;
                Caption = 'Job Details';
                SubPageLink = "No."=field("No.");
                Visible = JobSimplificationAvailable;
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
            group("&Job")
            {
                Caption = '&Job';
                Image = Job;
                action("Job &Planning Lines")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job &Planning Lines';
                    Image = JobLines;
                    ShortCutKey = 'Shift+Ctrl+P';
                    ToolTip = 'View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (Budget) or you can specify what you actually agreed with your customer that he should pay for the job (Billable).';

                    trigger OnAction()
                    var
                        JobPlanningLine: Record "Job Planning Line";
                        JobPlanningLines: Page "Job Planning Lines";
                    begin
                        TestField("No.");
                        JobPlanningLine.SetRange("Job No.","No.");
                        JobPlanningLines.SetJobNoVisible(false);
                        JobPlanningLines.SetTableview(JobPlanningLine);
                        JobPlanningLines.Editable := true;
                        JobPlanningLines.Run;
                    end;
                }
                action("&Dimensions")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(167),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View this job''s default dimensions.';
                }
                action("&Statistics")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View this job''s statistics.';
                }
                separator(Action64)
                {
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const(Job),
                                  "No."=field("No.");
                    ToolTip = 'View the comment sheet for this job.';
                }
                action("&Online Map")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Online Map';
                    Image = Map;
                    ToolTip = 'View online map for addresses assigned to this job.';

                    trigger OnAction()
                    begin
                        DisplayMap;
                    end;
                }
            }
            group("W&IP")
            {
                Caption = 'W&IP';
                Image = WIP;
                action("&WIP Entries")
                {
                    ApplicationArea = Jobs;
                    Caption = '&WIP Entries';
                    Image = WIPEntries;
                    RunObject = Page "Job WIP Entries";
                    RunPageLink = "Job No."=field("No.");
                    RunPageView = sorting("Job No.","Job Posting Group","WIP Posting Date")
                                  order(descending);
                    ToolTip = 'View entries for the job that are posted as work in process.';
                }
                action("WIP &G/L Entries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'WIP &G/L Entries';
                    Image = WIPLedger;
                    RunObject = Page "Job WIP G/L Entries";
                    RunPageLink = "Job No."=field("No.");
                    RunPageView = sorting("Job No.")
                                  order(descending);
                    ToolTip = 'View the job''s WIP G/L entries.';
                }
            }
            group("&Prices")
            {
                Caption = '&Prices';
                Image = Price;
                action("&Resource")
                {
                    ApplicationArea = Suite;
                    Caption = '&Resource';
                    Image = Resource;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Job Resource Prices";
                    RunPageLink = "Job No."=field("No.");
                    ToolTip = 'View this job''s resource prices.';
                }
                action("&Item")
                {
                    ApplicationArea = Suite;
                    Caption = '&Item';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Job Item Prices";
                    RunPageLink = "Job No."=field("No.");
                    ToolTip = 'View this job''s item prices.';
                }
                action("&G/L Account")
                {
                    ApplicationArea = Suite;
                    Caption = '&G/L Account';
                    Image = JobPrice;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Job G/L Account Prices";
                    RunPageLink = "Job No."=field("No.");
                    ToolTip = 'View this job''s G/L account prices.';
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                Image = Planning;
                action("Resource &Allocated per Job")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource &Allocated per Job';
                    Image = ViewJob;
                    RunObject = Page "Resource Allocated per Job";
                    ToolTip = 'View this job''s resource allocation.';
                }
                action("Res. Gr. All&ocated per Job")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Res. Gr. All&ocated per Job';
                    Image = ResourceGroup;
                    RunObject = Page "Res. Gr. Allocated per Job";
                    ToolTip = 'View the job''s resource group allocation.';
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Ledger E&ntries';
                    Image = JobLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No."=field("No.");
                    RunPageView = sorting("Job No.","Job Task No.","Entry Type","Posting Date")
                                  order(descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
        area(processing)
        {
            group("&Copy")
            {
                Caption = '&Copy';
                Image = Copy;
                action("Copy Job Tasks &from...")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Copy Job Tasks &from...';
                    Ellipsis = true;
                    Image = CopyToTask;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Open the Copy Job Tasks page.';

                    trigger OnAction()
                    var
                        CopyJobTasks: Page "Copy Job Tasks";
                    begin
                        CopyJobTasks.SetToJob(Rec);
                        CopyJobTasks.RunModal;
                    end;
                }
                action("Copy Job Tasks &to...")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Copy Job Tasks &to...';
                    Ellipsis = true;
                    Image = CopyFromTask;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Open the Copy Jobs To page.';

                    trigger OnAction()
                    var
                        CopyJobTasks: Page "Copy Job Tasks";
                    begin
                        CopyJobTasks.SetFromJob(Rec);
                        CopyJobTasks.RunModal;
                    end;
                }
            }
            group(ActionGroup26)
            {
                Caption = 'W&IP';
                Image = WIP;
                action("<Action82>")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Calculate WIP';
                    Ellipsis = true;
                    Image = CalculateWIP;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ToolTip = 'Run the Job Calculate WIP batch job.';

                    trigger OnAction()
                    var
                        Job: Record Job;
                    begin
                        TestField("No.");
                        Job.Copy(Rec);
                        Job.SetRange("No.","No.");
                        Report.RunModal(Report::"Job Calculate WIP",true,false,Job);
                    end;
                }
                action("<Action83>")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Post WIP to G/L';
                    Ellipsis = true;
                    Image = PostOrder;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ShortCutKey = 'F9';
                    ToolTip = 'Run the Job Post WIP to G/L batch job.';

                    trigger OnAction()
                    var
                        Job: Record Job;
                    begin
                        TestField("No.");
                        Job.Copy(Rec);
                        Job.SetRange("No.","No.");
                        Report.RunModal(Report::"Job Post WIP to G/L",true,false,Job);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Job Cost Budget")
            {
                ApplicationArea = Jobs;
                Caption = 'Job Cost Budget';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Job Cost Budget";
                ToolTip = 'View the job cost budgets for specific jobs or for all jobs. This report lists the step, task, and phase and the description of the activity. For each activity, the report includes the quantity, unit and total cost, and unit and total price.';
            }
            action("Job Analysis")
            {
                ApplicationArea = Suite;
                Caption = 'Job Analysis';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Job Analysis";
                ToolTip = 'Analyze the job, such as the budgeted prices, usage prices, and billable prices, and then compares the three sets of prices.';
            }
            action("Job - Planning Lines")
            {
                ApplicationArea = Suite;
                Caption = 'Job - Planning Lines';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Job - Planning Lines";
                ToolTip = 'View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (budget) or you can specify what you actually agreed with your customer that he should pay for the job (billable).';
            }
            action("Job Cost Transaction Detail")
            {
                ApplicationArea = Jobs;
                Caption = 'Job Cost Transaction Detail';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Job Cost Transaction Detail";
                ToolTip = 'List the details of your job transactions. The report includes the job number and description followed by a list of the transactions that occurred in the period you specify.';
            }
            action("Job Actual to Budget (Cost)")
            {
                ApplicationArea = Jobs;
                Caption = 'Job Actual to Budget (Cost)';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Job Actual to Budget (Cost)";
                ToolTip = 'Compare the actual cost of your jobs to the price that was budgeted. The report shows budget and actual amounts for each phase, task, and steps.';
            }
            action("Job Actual to Budget (Price)")
            {
                ApplicationArea = Jobs;
                Caption = 'Job Actual to Budget (Price)';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Job Actual to Budget (Price)";
                ToolTip = 'Compare the actual price of your jobs to the price that was budgeted. The report shows budget and actual amounts for each phase, task, and steps.';
            }
            action("Open Purchase Invoices by Job")
            {
                ApplicationArea = Jobs;
                Caption = 'Open Purchase Invoices by Job';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Open Purchase Invoices by Job";
                ToolTip = 'View open purchase invoices by job.';
            }
            action("Open Sales Invoices by Job")
            {
                ApplicationArea = Jobs;
                Caption = 'Open Sales Invoices by Job';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Open Sales Invoices by Job";
                ToolTip = 'View open sales invoices by job.';
            }
            action("Job Cost Suggested Billing")
            {
                ApplicationArea = Jobs;
                Caption = 'Job Cost Suggested Billing';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Job Cost Suggested Billing";
                ToolTip = 'Get suggestions on the amount you should bill a customer for a job. The suggested billing is based on the actual cost of the job less any amount that has already been invoiced to the customer.';
            }
            action("Report Job Quote")
            {
                ApplicationArea = Suite;
                Caption = 'Preview Job Quote';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'Open the Job Quote report.';

                trigger OnAction()
                var
                    Job: Record Job;
                begin
                    Job.SetCurrentkey("No.");
                    Job.SetFilter("No.","No.");
                    Report.Run(Report::"Job Quote",true,false,Job);
                end;
            }
            action("Send Job Quote")
            {
                ApplicationArea = Suite;
                Caption = 'Send Job Quote';
                Image = SendTo;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'Send the job quote to the customer. You can change the way that the document is sent in the window that appears.';

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Jobs-Send",Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrencyCheck;
    end;

    trigger OnInit()
    begin
        CurrencyCodeEditable := true;
        InvoiceCurrencyCodeEditable := true;
        JobSimplificationAvailable := IsJobSimplificationAvailable;
    end;

    var
        [InDataSet]
        InvoiceCurrencyCodeEditable: Boolean;
        [InDataSet]
        CurrencyCodeEditable: Boolean;
        JobSimplificationAvailable: Boolean;

    local procedure CurrencyCheck()
    begin
        if "Currency Code" <> ''then
          InvoiceCurrencyCodeEditable := false
        else
          InvoiceCurrencyCodeEditable := true;

        if "Invoice Currency Code" <> ''then
          CurrencyCodeEditable := false
        else
          CurrencyCodeEditable := true;
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;
}

