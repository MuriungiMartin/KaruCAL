#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9018 "Administrator Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1904484608;"IT Operations Activities")
                {
                }
                part(Control58;"CRM Synch. Job Status Part")
                {
                    Visible = false;
                }
                part(Control52;"Service Connections Part")
                {
                    Visible = false;
                }
            }
            group(Control1900724708)
            {
                part(Control36;"Report Inbox Part")
                {
                }
                part(Control32;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1903012608;"Copy Profile")
                {
                }
                systempart(Control1901377608;MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Check on Ne&gative Inventory")
            {
                ApplicationArea = Basic;
                Caption = 'Check on Ne&gative Inventory';
                Image = "Report";
                RunObject = Report "Items with Negative Inventory";
            }
        }
        area(embedding)
        {
            ToolTip = 'Set up users and cross-product values, such as number series and ZIP codes.';
            action("Job Queue Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Job Queue Entries';
                RunObject = Page "Job Queue Entries";
            }
            action("User Setup")
            {
                ApplicationArea = Basic;
                Caption = 'User Setup';
                Image = UserSetup;
                RunObject = Page "User Setup";
            }
            action("No. Series")
            {
                ApplicationArea = Basic;
                Caption = 'No. Series';
                RunObject = Page "No. Series";
            }
            action("Approval User Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Approval User Setup';
                RunObject = Page "Approval User Setup";
            }
            action("Workflow User Groups")
            {
                ApplicationArea = Basic;
                Caption = 'Workflow User Groups';
                Image = Users;
                RunObject = Page "Workflow User Groups";
            }
            action(Action57)
            {
                ApplicationArea = Basic;
                Caption = 'Workflows';
                Image = ApprovalSetup;
                RunObject = Page Workflows;
            }
            action("Data Templates List")
            {
                ApplicationArea = Basic;
                Caption = 'Data Templates List';
                RunObject = Page "Config. Template List";
            }
            action("Base Calendar List")
            {
                ApplicationArea = Basic;
                Caption = 'Base Calendar List';
                RunObject = Page "Base Calendar List";
            }
            action("ZIP Codes")
            {
                ApplicationArea = Basic;
                Caption = 'ZIP Codes';
                RunObject = Page "Post Codes";
            }
            action("Reason Codes")
            {
                ApplicationArea = Basic;
                Caption = 'Reason Codes';
                RunObject = Page "Reason Codes";
            }
            action("Extended Text")
            {
                ApplicationArea = Basic;
                Caption = 'Extended Text';
                RunObject = Page "Extended Text List";
            }
        }
        area(sections)
        {
            group("Job Queue")
            {
                Caption = 'Job Queue';
                Image = ExecuteBatch;
                ToolTip = 'Specify how reports, batch jobs, and codeunits are run.';
                action(JobQueue_JobQueueEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Queue Entries';
                    RunObject = Page "Job Queue Entries";
                }
                action("Job Queue Category List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Queue Category List';
                    RunObject = Page "Job Queue Category List";
                }
                action("Job Queue Log Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Queue Log Entries';
                    RunObject = Page "Job Queue Log Entries";
                }
            }
            group(Workflow)
            {
                Caption = 'Workflow';
                ToolTip = 'Set up workflow and approval users, and create workflows that govern how the users interact in processes.';
                action(Workflows)
                {
                    ApplicationArea = Basic;
                    Caption = 'Workflows';
                    Image = ApprovalSetup;
                    RunObject = Page Workflows;
                }
                action("Workflow Templates")
                {
                    ApplicationArea = Basic;
                    Caption = 'Workflow Templates';
                    Image = Setup;
                    RunObject = Page "Workflow Templates";
                }
                action(ApprovalUserSetup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approval User Setup';
                    RunObject = Page "Approval User Setup";
                }
                action(WorkflowUserGroups)
                {
                    ApplicationArea = Basic;
                    Caption = 'Workflow User Groups';
                    Image = Users;
                    RunObject = Page "Workflow User Groups";
                }
            }
            group(Intrastat)
            {
                Caption = 'Intrastat';
                Image = Intrastat;
                ToolTip = 'Set up Intrastat reporting values, such as tariff numbers.';
                action("Tariff Numbers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tariff Numbers';
                    RunObject = Page "Tariff Numbers";
                }
                action("Transaction Types")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transaction Types';
                    RunObject = Page "Transaction Types";
                }
                action("Transaction Specifications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transaction Specifications';
                    RunObject = Page "Transaction Specifications";
                }
                action("Transport Methods")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transport Methods';
                    RunObject = Page "Transport Methods";
                }
                action("Entry/Exit Points")
                {
                    ApplicationArea = Basic;
                    Caption = 'Entry/Exit Points';
                    RunObject = Page "Entry/Exit Points";
                }
                action(Areas)
                {
                    ApplicationArea = Basic;
                    Caption = 'Areas';
                    RunObject = Page Areas;
                }
            }
            group("Tax Registration Numbers")
            {
                Caption = 'Tax Registration Numbers';
                Image = Bank;
                ToolTip = 'Set up and maintain tax registration number formats.';
                action("Tax Registration No. Formats")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Registration No. Formats';
                    RunObject = Page "VAT Registration No. Formats";
                }
            }
            group("Analysis View")
            {
                Caption = 'Analysis View';
                Image = AnalysisView;
                ToolTip = 'Set up views for analysis of sales, purchases, and inventory.';
                action("Sales Analysis View List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Analysis View List';
                    RunObject = Page "Analysis View List Sales";
                }
                action("Purchase Analysis View List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Analysis View List';
                    RunObject = Page "Analysis View List Purchase";
                }
                action("Inventory Analysis View List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory Analysis View List';
                    RunObject = Page "Analysis View List Inventory";
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action("Pending My Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending My Approval';
                    RunObject = Page "Approval Entries";
                }
                action("My Approval requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approval requests';
                    RunObject = Page "Approval Request Entries";
                }
                action("Clearance Requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'Clearance Requests';
                    RunObject = Page "ACA-Clearance Approval Entries";
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action("Stores Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "PROC-Store Requisition";
                }
                action("Imprest Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Requisitions';
                    RunObject = Page "FIN-Imprest List UP";
                }
                action("Leave Applications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HRM-Leave Requisition List";
                }
                action("My Approved Leaves")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approved Leaves';
                    Image = History;
                    RunObject = Page "HRM-My Approved Leaves List";
                }
                action("File Requisitions")
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "REG-File Requisition List";
                }
                action("Meal Booking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Meal Booking';
                    RunObject = Page "CAT-Meal Booking List";
                }
            }
        }
        area(creation)
        {
            action("Change Password")
            {
                ApplicationArea = Basic;
                Caption = 'Change Password';
                Image = ChangeStatus;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Change Password";
            }
            action("Purchase &Order")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Action23)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Com&pany Information")
            {
                ApplicationArea = Basic;
                Caption = 'Com&pany Information';
                Image = CompanyInformation;
                RunObject = Page "Company Information";
            }
            action("&Manage Style Sheets")
            {
                ApplicationArea = Basic;
                Caption = '&Manage Style Sheets';
                Image = StyleSheet;
                RunObject = Page "IC Bank Account List";
            }
            action("Migration O&verview")
            {
                ApplicationArea = Basic;
                Caption = 'Migration O&verview';
                Image = Migration;
                RunObject = Page "Config. Package Card";
            }
            action("Relocate &Attachments")
            {
                ApplicationArea = Basic;
                Caption = 'Relocate &Attachments';
                Image = ChangeTo;
                RunObject = Report "Relocate Attachments";
            }
            action("Create Warehouse &Location")
            {
                ApplicationArea = Basic;
                Caption = 'Create Warehouse &Location';
                Image = NewWarehouse;
                RunObject = Report "Create Warehouse Location";
            }
            action("C&hange Log Setup")
            {
                ApplicationArea = Basic;
                Caption = 'C&hange Log Setup';
                Image = LogSetup;
                RunObject = Page "Change Log Setup";
            }
            separator(Action30)
            {
            }
            group("&Change Setup")
            {
                Caption = '&Change Setup';
                Image = Setup;
                action("Setup &Questionnaire")
                {
                    ApplicationArea = Basic;
                    Caption = 'Setup &Questionnaire';
                    Image = QuestionaireSetup;
                    RunObject = Page "Config. Questionnaire";
                }
                action("&General Ledger Setup")
                {
                    ApplicationArea = Basic;
                    Caption = '&General Ledger Setup';
                    Image = Setup;
                    RunObject = Page "General Ledger Setup";
                }
                action("Sales && Receiva&bles Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales && Receiva&bles Setup';
                    Image = Setup;
                    RunObject = Page "Sales & Receivables Setup";
                }
                action("Purchase && Pa&yables Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase && Pa&yables Setup';
                    Image = ReceivablesPayablesSetup;
                    RunObject = Page "Purchases & Payables Setup";
                }
                action("Fi&xed Asset Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fi&xed Asset Setup';
                    Image = Setup;
                    RunObject = Page "Fixed Asset Setup";
                }
                action("Mar&keting Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mar&keting Setup';
                    Image = MarketingSetup;
                    RunObject = Page "Marketing Setup";
                }
                action("Or&der Promising Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Or&der Promising Setup';
                    Image = OrderPromisingSetup;
                    RunObject = Page "Order Promising Setup";
                }
                action("Nonsto&ck Item Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonsto&ck Item Setup';
                    Image = NonStockItemSetup;
                    RunObject = Page "Catalog Item Setup";
                }
                action("Interaction &Template Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction &Template Setup';
                    Image = InteractionTemplateSetup;
                    RunObject = Page "Interaction Template Setup";
                }
                action("Inve&ntory Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Inve&ntory Setup';
                    Image = InventorySetup;
                    RunObject = Page "Inventory Setup";
                }
                action("&Warehouse Setup")
                {
                    ApplicationArea = Basic;
                    Caption = '&Warehouse Setup';
                    Image = WarehouseSetup;
                    RunObject = Page "Warehouse Setup";
                }
                action("Mini&forms")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mini&forms';
                    Image = MiniForm;
                    RunObject = Page Miniforms;
                }
                action("Man&ufacturing Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Man&ufacturing Setup';
                    Image = ProductionSetup;
                    RunObject = Page "Manufacturing Setup";
                }
                action("Res&ources Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Res&ources Setup';
                    Image = ResourceSetup;
                    RunObject = Page "Resources Setup";
                }
                action("&Service Setup")
                {
                    ApplicationArea = Basic;
                    Caption = '&Service Setup';
                    Image = ServiceSetup;
                    RunObject = Page "Service Mgt. Setup";
                }
                action("&Human Resource Setup")
                {
                    ApplicationArea = Basic;
                    Caption = '&Human Resource Setup';
                    Image = HRSetup;
                    RunObject = Page "Human Resources Setup";
                }
                action("Service Order Status Setu&p")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Order Status Setu&p';
                    Image = ServiceOrderSetup;
                    RunObject = Page "Service Order Status Setup";
                }
                action("&Repair Status Setup")
                {
                    ApplicationArea = Basic;
                    Caption = '&Repair Status Setup';
                    Image = ServiceSetup;
                    RunObject = Page "Repair Status Setup";
                }
                action("Ch&ange Log Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ch&ange Log Setup';
                    Image = LogSetup;
                    RunObject = Page "Change Log Setup";
                }
                action("&MapPoint Setup")
                {
                    ApplicationArea = Basic;
                    Caption = '&MapPoint Setup';
                    Image = MapSetup;
                    RunObject = Page "Online Map Setup";
                }
                action("SMTP Mai&l Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'SMTP Mai&l Setup';
                    Image = MailSetup;
                    RunObject = Page "SMTP Mail Setup";
                }
                action("Profile Quest&ionnaire Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Profile Quest&ionnaire Setup';
                    Image = QuestionaireSetup;
                    RunObject = Page "Profile Questionnaire Setup";
                }
            }
            group("&Report Selection")
            {
                Caption = '&Report Selection';
                Image = SelectReport;
                action("Report Selection - &Bank Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'Report Selection - &Bank Account';
                    Image = SelectReport;
                    RunObject = Page "Report Selection - Bank Acc.";
                }
                action("Report Selection - &Reminder && Finance Charge")
                {
                    ApplicationArea = Basic;
                    Caption = 'Report Selection - &Reminder && Finance Charge';
                    Image = SelectReport;
                    RunObject = Page "Report Selection - Reminder";
                }
                action("Report Selection - &Sales")
                {
                    ApplicationArea = Basic;
                    Caption = 'Report Selection - &Sales';
                    Image = SelectReport;
                    RunObject = Page "Report Selection - Sales";
                }
                action("Report Selection - &Purchase")
                {
                    ApplicationArea = Basic;
                    Caption = 'Report Selection - &Purchase';
                    Image = SelectReport;
                    RunObject = Page "Report Selection - Purchase";
                }
                action("Report Selection - &Inventory")
                {
                    ApplicationArea = Basic;
                    Caption = 'Report Selection - &Inventory';
                    Image = SelectReport;
                    RunObject = Page "Report Selection - Inventory";
                }
                action("Report Selection - Prod. &Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Report Selection - Prod. &Order';
                    Image = SelectReport;
                    RunObject = Page "Report Selection - Prod. Order";
                }
                action("Report Selection - S&ervice")
                {
                    ApplicationArea = Basic;
                    Caption = 'Report Selection - S&ervice';
                    Image = SelectReport;
                    RunObject = Page "Report Selection - Service";
                }
                action("Report Selection - Cash Flow")
                {
                    ApplicationArea = Basic;
                    Caption = 'Report Selection - Cash Flow';
                    Image = SelectReport;
                    RunObject = Page "Report Selection - Cash Flow";
                }
            }
            group("&Date Compression")
            {
                Caption = '&Date Compression';
                Image = Compress;
                action("Date Compress &G/L Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Compress &G/L Entries';
                    Image = GeneralLedger;
                    RunObject = Report "Date Compress General Ledger";
                }
                action("Date Compress &Tax Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Compress &Tax Entries';
                    Image = VATStatement;
                    RunObject = Report "Date Compress VAT Entries";
                }
                action("Date Compress Bank &Account Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Compress Bank &Account Ledger Entries';
                    Image = BankAccount;
                    RunObject = Report "Date Compress Bank Acc. Ledger";
                }
                action("Date Compress G/L &Budget Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Compress G/L &Budget Entries';
                    Image = LedgerBudget;
                    RunObject = Report "Date Compr. G/L Budget Entries";
                }
                action("Date Compress &Customer Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Compress &Customer Ledger Entries';
                    Image = Customer;
                    RunObject = Report "Date Compress Customer Ledger";
                }
                action("Date Compress V&endor Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Compress V&endor Ledger Entries';
                    Image = Vendor;
                    RunObject = Report "Date Compress Vendor Ledger";
                }
                action("Date Compress &Resource Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Compress &Resource Ledger Entries';
                    Image = Resource;
                    RunObject = Report "Date Compress Resource Ledger";
                }
                action("Date Compress &FA Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Compress &FA Ledger Entries';
                    Image = FixedAssets;
                    RunObject = Report "Date Compress FA Ledger";
                }
                action("Date Compress &Maintenance Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Compress &Maintenance Ledger Entries';
                    Image = Tools;
                    RunObject = Report "Date Compress Maint. Ledger";
                }
                action("Date Compress &Insurance Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Compress &Insurance Ledger Entries';
                    Image = Insurance;
                    RunObject = Report "Date Compress Insurance Ledger";
                }
                action("Date Compress &Warehouse Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Compress &Warehouse Entries';
                    Image = Bin;
                    RunObject = Report "Date Compress Whse. Entries";
                }
            }
            separator(Action264)
            {
            }
            group("Con&tacts")
            {
                Caption = 'Con&tacts';
                Image = CustomerContact;
                action("Create Contacts from &Customer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Contacts from &Customer';
                    Image = CustomerContact;
                    RunObject = Report "Create Conts. from Customers";
                }
                action("Create Contacts from &Vendor")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Contacts from &Vendor';
                    Image = VendorContact;
                    RunObject = Report "Create Conts. from Vendors";
                }
                action("Create Contacts from &Bank Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Contacts from &Bank Account';
                    Image = BankContact;
                    RunObject = Report "Create Conts. from Bank Accs.";
                }
                action("To-do &Activities")
                {
                    ApplicationArea = Basic;
                    Caption = 'To-do &Activities';
                    Image = TaskList;
                    RunObject = Page Activity;
                }
            }
            separator(Action47)
            {
            }
            action("Service Trou&bleshooting")
            {
                ApplicationArea = Basic;
                Caption = 'Service Trou&bleshooting';
                Image = Troubleshoot;
                RunObject = Page Troubleshooting;
            }
            group("&Import")
            {
                Caption = '&Import';
                Image = Import;
                action("Import IRIS to &Area/Symptom Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import IRIS to &Area/Symptom Code';
                    Image = Import;
                    RunObject = XMLport "Imp. IRIS to Area/Symptom Code";
                }
                action("Import IRIS to &Fault Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import IRIS to &Fault Codes';
                    Image = Import;
                    RunObject = XMLport "Import IRIS to Fault Codes";
                }
                action("Import IRIS to &Resolution Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import IRIS to &Resolution Codes';
                    Image = Import;
                    RunObject = XMLport "Import IRIS to Resol. Codes";
                }
            }
            separator(Action263)
            {
            }
            group("&Sales Analysis")
            {
                Caption = '&Sales Analysis';
                Image = Segment;
                action(SalesAnalysisLineTmpl)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Analysis &Line Templates';
                    Image = SetupLines;
                    RunObject = Page "Analysis Line Templates";
                    RunPageView = sorting("Analysis Area",Name)
                                  where("Analysis Area"=const(Sales));
                }
                action(SalesAnalysisColumnTmpl)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Analysis &Column Templates';
                    Image = SetupColumns;
                    RunObject = Page "Analysis Column Templates";
                    RunPageView = sorting("Analysis Area",Name)
                                  where("Analysis Area"=const(Sales));
                }
            }
            group("P&urchase Analysis")
            {
                Caption = 'P&urchase Analysis';
                Image = Purchasing;
                action(PurchaseAnalysisLineTmpl)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase &Analysis Line Templates';
                    Image = SetupLines;
                    RunObject = Page "Analysis Line Templates";
                    RunPageView = sorting("Analysis Area",Name)
                                  where("Analysis Area"=const(Purchase));
                }
                action(PurchaseAnalysisColumnTmpl)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Analysis &Column Templates';
                    Image = SetupColumns;
                    RunObject = Page "Analysis Column Templates";
                    RunPageView = sorting("Analysis Area",Name)
                                  where("Analysis Area"=const(Purchase));
                }
            }
        }
    }
}

