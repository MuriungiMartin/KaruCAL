#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9015 "Job Project Manager RC"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control33;"Project Manager Activities")
                {
                    ApplicationArea = Jobs;
                }
                part(Control1020001;"Team Member Activities")
                {
                    ApplicationArea = Suite;
                }
                part(Control34;"My Jobs")
                {
                    ApplicationArea = Jobs;
                }
                part("Job Actual Price to Budget Price";"Job Act to Bud Price Chart")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Actual Price to Budget Price';
                }
            }
            group(Control1900724708)
            {
                part("Job Profitability";"Job Profitability Chart")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Profitability';
                }
                part("Job Actual Cost to Budget Cost";"Job Act to Bud Cost Chart")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Actual Cost to Budget Cost';
                }
                part(Control1907692008;"My Customers")
                {
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                part(Control21;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1903012608;"Copy Profile")
                {
                    Visible = false;
                }
                part(Control31;"Report Inbox Part")
                {
                    Visible = false;
                }
                systempart(Control1901377608;MyNotes)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action(Jobs)
            {
                ApplicationArea = Jobs;
                Caption = 'Jobs';
                Image = Job;
                RunObject = Page "Job List";
                ToolTip = 'View all jobs.';
            }
            action(JobsOnOrder)
            {
                ApplicationArea = Jobs;
                Caption = 'Open';
                RunObject = Page "Job List";
                RunPageView = where(Status=filter(Open));
                ToolTip = 'View all jobs on order.';
            }
            action(JobsPlannedAndQuoted)
            {
                ApplicationArea = Jobs;
                Caption = 'Planned and Quoted';
                RunObject = Page "Job List";
                RunPageView = where(Status=filter(Quote|Planning));
                ToolTip = 'View all planned and quoted jobs.';
            }
            action(JobsCompleted)
            {
                ApplicationArea = Jobs;
                Caption = 'Completed';
                RunObject = Page "Job List";
                RunPageView = where(Status=filter(Completed));
                ToolTip = 'View all completed jobs.';
            }
            action(JobsUnassigned)
            {
                ApplicationArea = Jobs;
                Caption = 'Unassigned';
                RunObject = Page "Job List";
                RunPageView = where("Person Responsible"=filter(''));
                ToolTip = 'View all unassigned jobs.';
            }
            action("Job Tasks")
            {
                ApplicationArea = Suite;
                Caption = 'Job Tasks';
                RunObject = Page "Job Task List";
                ToolTip = 'View all job tasks.';
            }
            action("Sales Invoices")
            {
                ApplicationArea = Jobs;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List";
                ToolTip = 'View all sales invoices.';
            }
            action("Sales Credit Memos")
            {
                ApplicationArea = Jobs;
                Caption = 'Sales Credit Memos';
                RunObject = Page "Sales Credit Memos";
                ToolTip = 'View all sales credit memos.';
            }
            action("Purchase Orders")
            {
                ApplicationArea = Suite;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
                ToolTip = 'View all purchase orders.';
            }
            action("Purchase Invoices")
            {
                ApplicationArea = Suite;
                Caption = 'Purchase Invoices';
                RunObject = Page "Purchase Invoices";
                ToolTip = 'View all purchase invoices.';
            }
            action("Purchase Credit Memos")
            {
                ApplicationArea = Suite;
                Caption = 'Purchase Credit Memos';
                RunObject = Page "Purchase Credit Memos";
                ToolTip = 'View all purchase credit memos.';
            }
            action(Resources)
            {
                ApplicationArea = Jobs;
                Caption = 'Resources';
                RunObject = Page "Resource List";
                ToolTip = 'View all resources.';
            }
            action("Resource Groups")
            {
                ApplicationArea = Suite;
                Caption = 'Resource Groups';
                RunObject = Page "Resource Groups";
                ToolTip = 'View all resource groups.';
            }
            action(Items)
            {
                ApplicationArea = Jobs;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'View all items.';
            }
            action(Customers)
            {
                ApplicationArea = Jobs;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'View all customers.';
            }
            action("Time Sheets")
            {
                ApplicationArea = Jobs;
                Caption = 'Time Sheets';
                RunObject = Page "Time Sheet List";
                ToolTip = 'View all time sheets.';
            }
            action("Page Manager Time Sheet List")
            {
                ApplicationArea = Jobs;
                Caption = 'Manager Time Sheets';
                RunObject = Page "Manager Time Sheet List";
                ToolTip = 'Open the Manager Time Sheet list.';
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action(JobJournals)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Journals';
                    RunObject = Page "Job Journal Batches";
                    RunPageView = where(Recurring=const(false));
                    ToolTip = 'View all job journals.';
                }
                action(JobGLJournals)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job G/L Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type"=const(Jobs),
                                        Recurring=const(false));
                    ToolTip = 'View all job G/L journals.';
                }
                action(ResourceJournals)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Journals';
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageView = where(Recurring=const(false));
                    ToolTip = 'View all resource journals.';
                }
                action(ItemJournals)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Item),
                                        Recurring=const(false));
                    ToolTip = 'View all item journals.';
                }
                action(RecurringJobJournals)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Recurring Job Journals';
                    RunObject = Page "Job Journal Batches";
                    RunPageView = where(Recurring=const(true));
                    ToolTip = 'View all recurring job journals.';
                }
                action(RecurringResourceJournals)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Recurring Resource Journals';
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageView = where(Recurring=const(true));
                    ToolTip = 'View all recurring resource journals.';
                }
                action(RecurringItemJournals)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Recurring Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = where("Template Type"=const(Item),
                                        Recurring=const(true));
                    ToolTip = 'View all recurring item journals.';
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View history for sales, shipments, and inventory.';
                action("Posted Shipments")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Posted Shipments';
                    RunObject = Page "Posted Sales Shipments";
                    ToolTip = 'View all posted sales shipments.';
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'View all posted sales invoices.';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'View all posted sales credit memos.';
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                    ToolTip = 'View all purchase receipts.';
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'View all posted purchase invoices.';
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'View all posted purchase credit memos.';
                }
                action("G/L Registers")
                {
                    ApplicationArea = Jobs;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                    ToolTip = 'View all G/L registers.';
                }
                action("Job Registers")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Registers';
                    Image = JobRegisters;
                    RunObject = Page "Job Registers";
                    ToolTip = 'View all job registers.';
                }
                action("Item Registers")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Item Registers';
                    Image = ItemRegisters;
                    RunObject = Page "Item Registers";
                    ToolTip = 'View all item registers.';
                }
                action("Resource Registers")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Registers';
                    Image = ResourceRegisters;
                    RunObject = Page "Resource Registers";
                    ToolTip = 'View all resource registers.';
                }
            }
            group("Self-Service")
            {
                Caption = 'Self-Service';
                Image = HumanResources;
                ToolTip = 'Manage your time sheets and assignments.';
                action(Action82)
                {
                    ApplicationArea = Suite;
                    Caption = 'Time Sheets';
                    Gesture = None;
                    RunObject = Page "Time Sheet List";
                    ToolTip = 'View all time sheets.';
                }
            }
        }
        area(processing)
        {
            group(NewGroup)
            {
                Caption = 'New';
                action("Page Job")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Job Creation Wizard";
                    RunPageMode = Create;
                    ToolTip = 'Create a new job.';
                }
                action("Job J&ournal")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job J&ournal';
                    Image = JobJournal;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Job Journal";
                    ToolTip = 'Open the Edit Job Journal page.';
                }
                action("Job G/L &Journal")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job G/L &Journal';
                    Image = GLJournal;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Job G/L Journal";
                    ToolTip = 'Open the Edit Job G/L Journal page.';
                }
                action("R&esource Journal")
                {
                    ApplicationArea = Suite;
                    Caption = 'R&esource Journal';
                    Image = ResourceJournal;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Resource Journal";
                    ToolTip = 'Open the Edit Resource Journal page.';
                }
                action("Job &Create Sales Invoice")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job &Create Sales Invoice';
                    Image = CreateJobSalesInvoice;
                    RunObject = Report "Job Create Sales Invoice";
                    ToolTip = 'Run the Job Create Sales Invoice report.';
                }
                action("Update Job I&tem Cost")
                {
                    ApplicationArea = Suite;
                    Caption = 'Update Job I&tem Cost';
                    Image = "Report";
                    RunObject = Report "Update Job Item Cost";
                    ToolTip = 'Run Update Job Item Cost report.';
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                group("Job Reports")
                {
                    Caption = 'Job Reports';
                    Image = ReferenceData;
                    action("Job List")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job List';
                        Image = "Report";
                        RunObject = Report "Job List";
                    }
                    action("Completed Jobs")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Completed Jobs';
                        Image = "Report";
                        RunObject = Report "Completed Jobs";
                    }
                    action("Job &Analysis")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job &Analysis';
                        Image = "Report";
                        RunObject = Report "Job Analysis";
                        ToolTip = 'View the Job Analysis report.';
                    }
                    action("Job Actual To &Budget (Cost)")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Actual To &Budget (Cost)';
                        Image = "Report";
                        RunObject = Report "Job Actual to Budget (Cost)";
                        ToolTip = 'View the Job Actual to Budget report.';
                    }
                    action("Job Actual to Budget (Price)")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Actual to Budget (Price)';
                        Image = "Report";
                        RunObject = Report "Job Actual to Budget (Price)";
                    }
                    action("Job Cost Transaction Detail")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Cost Transaction Detail';
                        Image = "Report";
                        RunObject = Report "Job Cost Transaction Detail";
                    }
                    action("Job - Pla&nning Line")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job - Pla&nning Line';
                        Image = "Report";
                        RunObject = Report "Job - Planning Lines";
                        ToolTip = 'View the Job Planning Line report.';
                    }
                    separator(Action16)
                    {
                    }
                    action("Job Cost Su&ggested Billing")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Cost Su&ggested Billing';
                        Image = "Report";
                        RunObject = Report "Job Cost Suggested Billing";
                        ToolTip = 'View the Job Suggested Billing report.';
                    }
                    action("Customer Jobs (Cost)")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Customer Jobs (Cost)';
                        Image = "Report";
                        RunObject = Report "Customer Jobs (Cost)";
                        ToolTip = 'View the Jobs per Customer report.';
                    }
                    action("Customer Jobs (Price)")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Customer Jobs (Price)';
                        Image = "Report";
                        RunObject = Report "Customer Jobs (Price)";
                    }
                    action("Items per &Job")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Items per &Job';
                        Image = "Report";
                        RunObject = Report "Items per Job";
                        ToolTip = 'View the Items per Job report.';
                    }
                    action("Jobs per &Item")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Jobs per &Item';
                        Image = "Report";
                        RunObject = Report "Jobs per Item";
                        ToolTip = 'View the Jobs per Item report.';
                    }
                }
            }
            group(Manage)
            {
                Caption = 'Manage';
                group(Timesheet)
                {
                    Caption = 'Time Sheet';
                    Image = Worksheets;
                    action("Create Time Sheets")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Create Time Sheets';
                        Image = JobTimeSheet;
                        RunObject = Report "Create Time Sheets";
                        ToolTip = 'Create new time sheets for selected resources.';
                    }
                    action("Manage Time Sheets")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Manager Time Sheets';
                        Image = JobTimeSheet;
                        RunObject = Page "Manager Time Sheet";
                        ToolTip = 'Open a list of time sheets by resource.';
                    }
                    action("Manager Time Sheet by Job")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Manager Time Sheet by Job';
                        Image = JobTimeSheet;
                        RunObject = Page "Manager Time Sheet by Job";
                        ToolTip = 'Open a list of time sheets by job.';
                    }
                    separator(Action5)
                    {
                    }
                    separator(Action7)
                    {
                    }
                }
                group(WIP)
                {
                    Caption = 'Job Closing';
                    Image = Job;
                    action("Job Calculate &WIP")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Calculate &WIP';
                        Image = CalculateWIP;
                        RunObject = Report "Job Calculate WIP";
                        ToolTip = 'Calculate the general ledger entries needed to update or close the job.';
                    }
                    action("Jo&b Post WIP to G/L")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Jo&b Post WIP to G/L';
                        Image = PostOrder;
                        RunObject = Report "Job Post WIP to G/L";
                        ToolTip = 'Post to the general ledger the entries calculated for your jobs.';
                    }
                    action("Job WIP")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Job WIP';
                        Image = WIP;
                        RunObject = Page "Job WIP Cockpit";
                        ToolTip = 'Overview of Job WIP';
                    }
                }
            }
            group(History)
            {
                Caption = 'History';
                action("Navi&gate")
                {
                    ApplicationArea = Suite;
                    Caption = 'Navi&gate';
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ToolTip = 'Open the Navigate page.';
                }
            }
        }
    }
}

