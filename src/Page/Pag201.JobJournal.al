#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 201 "Job Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Job Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Job Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = Jobs;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    JobJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    JobJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("Line Type";"Line Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the line type of a job planning line in the context of posting of a job ledger entry. The options are described in the following table.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting date you want to assign to each journal line. For more information, see Entering Dates and Times.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date on the document that provided the basis for this entry.';
                    Visible = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a document number that refers to the numbering system of either a customer or vendor associated with the items on this journal line.';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the related job.';

                    trigger OnValidate()
                    begin
                        JobJnlManagement.GetNames(Rec,JobDescription,AccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the related job task number.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an account type for job usage to be posted in the job journal. You can choose from the following options:';

                    trigger OnValidate()
                    begin
                        JobJnlManagement.GetNames(Rec,JobDescription,AccName);
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the resource, item, or general ledger account number that this entry applies to. The No. must correspond to your selection in the Type field. Choose the field to see the available accounts.';

                    trigger OnValidate()
                    begin
                        JobJnlManagement.GetNames(Rec,JobDescription,AccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the name of the resource, item, or general ledger account to which this entry applies. You can change the description.';
                }
                field("Job Planning Line No.";"Job Planning Line No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job planning line number to which the usage should be linked when the Job Journal is posted. You can only link to Job Planning Lines that have the Apply Usage Link option enabled.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an item variant code if the Type field is Item.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Jobs;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a location code for an item.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a bin code if you have entered a code in the Location Code field.';
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies which work type the resource applies to. Prices are updated based on this entry.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job''s currency code that listed in the Currency Code field in the Job Card. You can only create a Job Journal using this currency code.';
                    Visible = false;

                    trigger OnAssistEdit()
                    var
                        ChangeExchangeRate: Page "Change Exchange Rate";
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        if ChangeExchangeRate.RunModal = Action::OK then
                          Validate("Currency Factor",ChangeExchangeRate.GetParameter);

                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit of measure code used to determine the unit price. The code specifies how the quantity is measured. The application retrieves this code from the corresponding item or resource card. To see the units of measure that are available, choose the field.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of units of the job journal''s No. field, that is, either the resource, item, or G/L account number, that applies. If you later change the value in the No. field, the quantity does not change on the journal line.';
                }
                field("Remaining Qty.";"Remaining Qty.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity of the resource or item that remains to complete a job. The remaining quantity is calculated as the difference between Quantity and Qty. Posted. You can modify this field to indicate the quantity you want to remain on the job planning line after you post usage.';
                    Visible = false;
                }
                field("Direct Unit Cost (LCY)";"Direct Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the direct unit cost of one unit of the selected Type and No. The amount is in the local currency.';
                    Visible = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit cost for the selected Type and No. on the journal line. The unit cost is in the job currency, derived from the Currency Code field on the Job Card.';
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit cost for the selected Type and No. on the journal line. The unit cost is in the local currency.';
                }
                field("Total Cost";"Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost for the journal line. The total cost is calculated based on the job currency, which comes from the Currency Code field on the Job card.';
                }
                field("Total Cost (LCY)";"Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost for this journal line. The amount is in the local currency.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit price for the selected Type and No. on the journal line. The unit price is in the job currency, which comes from the Currency Code field on the Job Card.';
                }
                field("Unit Price (LCY)";"Unit Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit price of the selected Type and No. The amount is in the local currency.';
                    Visible = false;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.';
                }
                field("Line Amount (LCY)";"Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the net amount in ($) (before subtracting the invoice discount amount) that must be paid for the items on the line.';
                    Visible = false;
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount of the discount that applies to the journal line.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the line discount percentage.';
                }
                field("Total Price";"Total Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total price in the job currency on the journal line.';
                    Visible = false;
                }
                field("Total Price (LCY)";"Total Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total price for the journal line. The amount is in the local currency.';
                    Visible = false;
                }
                field("Applies-to Entry";"Applies-to Entry")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies if the job journal line has of type Item and the usage of the item will be applied to an already-posted item ledger entry. If this is the case, enter the entry number that the usage will be applied to.';
                }
                field("Applies-from Entry";"Applies-from Entry")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the item ledger entry that the journal line costs have been applied from. This should be done when you reverse the usage of an item in a job and you want to return the item to inventory at the same cost as before it was used in the job.';
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the country/region code that applies to the journal line.';
                    Visible = false;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general product posting group. The field is filled automatically when you retrieve a resource, an item, or a G/L account in the current line.';
                    Visible = false;
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for the transport method.';
                    Visible = false;
                }
                field("Time Sheet No.";"Time Sheet No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of a time sheet. A number is assigned to each time sheet when it is created. You cannot edit the number.';
                    Visible = false;
                }
                field("Time Sheet Line No.";"Time Sheet Line No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the line number for a time sheet.';
                    Visible = false;
                }
                field("Time Sheet Date";"Time Sheet Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date that a time sheet is created.';
                    Visible = false;
                }
            }
            group(Control73)
            {
                fixed(Control1902114901)
                {
                    group("Job Description")
                    {
                        Caption = 'Job Description';
                        field(JobDescription;JobDescription)
                        {
                            ApplicationArea = Jobs;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        field(AccName;AccName)
                        {
                            ApplicationArea = Jobs;
                            Caption = 'Account Name';
                            Editable = false;
                            ToolTip = 'Specifies the name of the customer or vendor that the job is related to.';
                        }
                    }
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
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Jobs;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action(ItemTrackingLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines(false);
                    end;
                }
            }
            group("&Job")
            {
                Caption = '&Job';
                Image = Job;
                action(Card)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Job Card";
                    RunPageLink = "No."=field("Job No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record that is being processed on the journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No."=field("Job No.");
                    RunPageView = sorting("Job No.","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CalcRemainingUsage)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Calc. Remaining Usage';
                    Ellipsis = true;
                    Image = CalculateRemainingUsage;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Calculate the remaining usage for the job. The batch job calculates, for each job task, the difference between scheduled usage of items, resources, and expenses and actual usage posted in job ledger entries. The remaining usage is then displayed in the job journal from where you can post it.';

                    trigger OnAction()
                    var
                        JobCalcRemainingUsage: Report "Job Calc. Remaining Usage";
                    begin
                        TestField("Journal Template Name");
                        TestField("Journal Batch Name");
                        Clear(JobCalcRemainingUsage);
                        JobCalcRemainingUsage.SetBatch("Journal Template Name","Journal Batch Name");
                        JobCalcRemainingUsage.SetDocNo("Document No.");
                        JobCalcRemainingUsage.RunModal;
                    end;
                }
                action(SuggestLinesFromTimeSheets)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Suggest Lines from Time Sheets';
                    Ellipsis = true;
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Fill the journal with lines that exist in the time sheets.';

                    trigger OnAction()
                    var
                        SuggestJobJnlLines: Report "Suggest Job Jnl. Lines";
                    begin
                        SuggestJobJnlLines.SetJobJnlLine(Rec);
                        SuggestJobJnlLines.RunModal;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Reconcile)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';
                    ToolTip = 'View what has been reconciled for the job. The window shows the quantity entered on the job journal lines, totaled by unit of measure and by work type.';

                    trigger OnAction()
                    begin
                        JobJnlReconcile.SetJobJnlLine(Rec);
                        JobJnlReconcile.Run;
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintJobJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = Jobs;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Job Jnl.-Post",Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Job Jnl.-Post+Print",Rec);
                        CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        JobJnlManagement.GetNames(Rec,JobDescription,AccName);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveJobJnlLine: Codeunit "Job Jnl. Line-Reserve";
    begin
        Commit;
        if not ReserveJobJnlLine.DeleteLineConfirm(Rec) then
          exit(false);
        ReserveJobJnlLine.DeleteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        if IsOpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          JobJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
          exit;
        end;
        JobJnlManagement.TemplateSelection(Page::"Job Journal",false,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        JobJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        JobJnlManagement: Codeunit JobJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        JobJnlReconcile: Page "Job Journal Reconcile";
        JobDescription: Text[50];
        AccName: Text[50];
        CurrentJnlBatchName: Code[10];
        ShortcutDimCode: array [8] of Code[20];

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        JobJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.Update(false);
    end;
}

