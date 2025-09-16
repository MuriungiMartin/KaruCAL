#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1310 "O365 Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Activities Cue";

    layout
    {
        area(content)
        {
            cuegroup(Welcome)
            {
                Caption = 'Welcome';
                Visible = TileGettingStartedVisible;

                actions
                {
                    action(GettingStartedTile)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Return to Getting Started';
                        Image = TileVideo;
                        ToolTip = 'Learn how to get started with Dynamics 365 for Financials.';

                        trigger OnAction()
                        begin
                            O365GettingStartedMgt.LaunchWizard(true,false);
                        end;
                    }
                }
            }
            cuegroup("Ongoing Sales")
            {
                Caption = 'Ongoing Sales';
                Visible = ShowSalesActivities;
                field("Ongoing Sales Quotes";"Ongoing Sales Quotes")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Quotes';
                    DrillDownPageID = "Sales Quotes";
                    ToolTip = 'Specifies sales quotes that have not yet been converted to invoices or orders.';
                }
                field("Ongoing Sales Orders";"Ongoing Sales Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Orders';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies sales orders that are not yet posted or only partially posted.';
                }
                field("Ongoing Sales Invoices";"Ongoing Sales Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Invoices';
                    DrillDownPageID = "Sales Invoice List";
                    ToolTip = 'Specifies sales invoices that are not yet posted or only partially posted.';
                }
                field("Sales This Month";"Sales This Month")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Sales Invoice List";
                    ToolTip = 'Specifies the sum of sales in the current month.';

                    trigger OnDrillDown()
                    begin
                        ActivitiesMgt.DrillDownSalesThisMonth;
                    end;
                }
            }
            cuegroup("Document Exchange Service")
            {
                Caption = 'Document Exchange Service';
                Visible = ShowDocumentsPendingDocExchService;
                field("Sales Inv. - Pending Doc.Exch.";"Sales Inv. - Pending Doc.Exch.")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Posted Sales Invoices";
                    ToolTip = 'Specifies sales invoices that await sending to the customer through the document exchange service.';
                    Visible = ShowDocumentsPendingDocExchService;
                }
                field("Sales CrM. - Pending Doc.Exch.";"Sales CrM. - Pending Doc.Exch.")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Posted Sales Credit Memos";
                    ToolTip = 'Specifies sales credit memos that await sending to the customer through the document exchange service.';
                    Visible = ShowDocumentsPendingDocExchService;
                }
            }
            cuegroup(Control9)
            {
                Caption = 'Purchases';
                Visible = ShowPurchasesActivities;
                field("Purchase Orders";"Purchase Orders")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies purchases orders that are not posted or only partially posted.';
                }
                field("Ongoing Purchase Invoices";"Ongoing Purchase Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Purchase Invoices";
                    ToolTip = 'Specifies purchases invoices that are not posted or only partially posted.';
                }
                field("Overdue Purch. Invoice Amount";"Overdue Purch. Invoice Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sum of your overdue payments to vendors.';

                    trigger OnDrillDown()
                    begin
                        ActivitiesMgt.DrillDownOverduePurchaseInvoiceAmount;
                    end;
                }
                field("Purch. Invoices Due Next Week";"Purch. Invoices Due Next Week")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of payments to vendors that are due next week.';
                }
            }
            cuegroup(Approvals)
            {
                Caption = 'Approvals';
                Visible = false;
                field("Requests to Approve";"Requests to Approve")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Requests to Approve";
                    ToolTip = 'Specifies the number of approval requests that require your approval.';
                }
            }
            cuegroup(Control12)
            {
                Caption = 'Payments';
                Visible = ShowPaymentsActivities;
                field("Overdue Sales Invoice Amount";"Overdue Sales Invoice Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sum of overdue payments from customers.';

                    trigger OnDrillDown()
                    begin
                        ActivitiesMgt.DrillDownCalcOverdueSalesInvoiceAmount;
                    end;
                }
                field("Non-Applied Payments";"Non-Applied Payments")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Unprocessed Payments';
                    Image = Cash;
                    ToolTip = 'Specifies imported bank transactions for payments that are not yet reconciled in the Payment Reconciliation Journal window.';

                    trigger OnDrillDown()
                    begin
                        Codeunit.Run(Codeunit::"Pmt. Rec. Journals Launcher");
                    end;
                }
                field("Average Collection Days";"Average Collection Days")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how long customers took to pay invoices in the last three months. This is the average number of days from when invoices are issued to when customers pay the invoices.';
                }
            }
            cuegroup(Camera)
            {
                Caption = 'Camera';
                Visible = ShowCamera;

                actions
                {
                    action(CreateIncomingDocumentFromCamera)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Create Incoming Doc. from Camera';
                        Image = TileCamera;
                        ToolTip = 'Create an incoming document by taking a photo of the document with your mobile device camera. The photo will be attached to the new document.';

                        trigger OnAction()
                        var
                            CameraOptions: dotnet CameraOptions;
                        begin
                            if not HasCamera then
                              exit;

                            CameraOptions := CameraOptions.CameraOptions;
                            CameraOptions.Quality := 100; // 100%
                            CameraProvider.RequestPictureAsync(CameraOptions);
                        end;
                    }
                }
            }
            cuegroup("Incoming Documents")
            {
                Caption = 'Incoming Documents';
                Visible = ShowIncomingDocuments;
                field("My Incoming Documents";"My Incoming Documents")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies incoming documents that are assigned to you.';
                }
                field("Awaiting Verfication";"Inc. Doc. Awaiting Verfication")
                {
                    ApplicationArea = Suite;
                    DrillDown = true;
                    ToolTip = 'Specifies incoming documents in OCR processing that require you to log on to the OCR service website to manually verify the OCR values before the documents can be received.';
                    Visible = ShowAwaitingIncomingDoc;

                    trigger OnDrillDown()
                    var
                        OCRServiceSetup: Record "OCR Service Setup";
                    begin
                        if OCRServiceSetup.Get then
                          if OCRServiceSetup.Enabled then
                            Hyperlink(OCRServiceSetup."Sign-in URL");
                    end;
                }
            }
            cuegroup(Control14)
            {
                Caption = 'Start';
                Visible = ShowStartActivities;

                actions
                {
                    action("Sales Quote")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Sales Quote';
                        Image = TileNew;
                        RunObject = Page "Sales Quote";
                        RunPageMode = Create;
                        ToolTip = 'Offer items or services to a customer.';
                    }
                    action("Sales Order")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Sales Order';
                        Image = TileNew;
                        RunObject = Page "Sales Order";
                        RunPageMode = Create;
                        ToolTip = 'Create a new sales order for items or services that require partial posting.';
                    }
                    action("Sales Invoice")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Sales Invoice';
                        Image = TileNew;
                        RunObject = Page "Sales Invoice";
                        RunPageMode = Create;
                        ToolTip = 'Create a new invoice for items or services. Invoice quantities cannot be posted partially.';
                    }
                    action("Purchase Invoice")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Purchase Invoice';
                        Image = TileNew;
                        RunObject = Page "Purchase Invoice";
                        RunPageMode = Create;
                        ToolTip = 'Create a new purchase invoice for items or services.';
                    }
                }
            }
            cuegroup("Get started")
            {
                Caption = 'Get started';
                Visible = ReplayGettingStartedVisible;

                actions
                {
                    action(ShowStartInMyCompany)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Try with my own data';
                        Image = TileSettings;
                        ToolTip = 'Set up My Company with the settings you choose. We''ll show you how, it''s easy.';
                        Visible = false;

                        trigger OnAction()
                        begin
                            if UserTours.IsAvailable then
                              UserTours.StartUserTour(O365GettingStartedMgt.GetChangeCompanyTourID);
                        end;
                    }
                    action(ReplayGettingStarted)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Replay Getting Started';
                        Image = TileVideo;
                        ToolTip = 'Show the Getting Started guide again.';

                        trigger OnAction()
                        var
                            O365GettingStarted: Record "O365 Getting Started";
                        begin
                            if O365GettingStarted.Get(UserId,CurrentClientType) then begin
                              O365GettingStarted."Tour in Progress" := false;
                              O365GettingStarted."Current Page" := 1;
                              O365GettingStarted.Modify;
                              Commit;
                            end;

                            O365GettingStartedMgt.LaunchWizard(true,false);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
            group("Show/Hide Activities")
            {
                Caption = 'Show/Hide Activities';
                Image = Answers;
                action("Sales ")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales';
                    Image = Sales;
                    RunObject = Codeunit "Sales Activities Mgt.";
                }
                action(Purchases)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchases';
                    Image = Purchase;
                    RunObject = Codeunit "Trial Balance Cache Mgt.";
                }
                action(Payments)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payments';
                    Image = Payment;
                    RunObject = Codeunit "Template Feature Mgt.";
                }
                action("Incoming Documents")
                {
                    ApplicationArea = Suite;
                    Caption = 'Incoming Documents';
                    Image = Documents;
                    RunObject = Codeunit "Inc. Doc. Activities Mgt.";
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';
                }
                action(Start)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Start';
                    Image = NewDocument;
                    RunObject = Codeunit "Top Customers By Sales Job";
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        O365GettingStartedMgt.UpdateGettingStartedVisible(TileGettingStartedVisible,ReplayGettingStartedVisible);
    end;

    trigger OnAfterGetRecord()
    var
        DocExchServiceSetup: Record "Doc. Exch. Service Setup";
    begin
        CalculateCueFieldValues;
        ShowDocumentsPendingDocExchService := false;
        if DocExchServiceSetup.Get then
          ShowDocumentsPendingDocExchService := DocExchServiceSetup.Enabled;
        SetActivityGroupVisibility;
    end;

    trigger OnInit()
    begin
        O365GettingStartedMgt.UpdateGettingStartedVisible(TileGettingStartedVisible,ReplayGettingStartedVisible);
    end;

    trigger OnOpenPage()
    var
        OCRServiceMgt: Codeunit "OCR Service Mgt.";
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
        SetFilter("Due Date Filter",'>=%1',WorkDate);
        SetFilter("Overdue Date Filter",'<%1',WorkDate);
        SetFilter("Due Next Week Filter",'%1..%2',CalcDate('<1D>',WorkDate),CalcDate('<1W>',WorkDate));
        SetRange("User ID Filter",UserId);

        HasCamera := CameraProvider.IsAvailable;
        if HasCamera then
          CameraProvider := CameraProvider.Create;

        if UserTours.IsAvailable then begin
          UserTours := UserTours.Create;
          UserTours.NotifyShowTourWizard;
          if O365GettingStartedMgt.IsGettingStartedSupported then
            UserTours.ShowPlayer
          else
            UserTours.HidePlayer;
        end else
          if PageNotifier.IsAvailable then begin
            PageNotifier := PageNotifier.Create;
            PageNotifier.NotifyPageReady;
          end;

        ShowCamera := true;
        ShowStartActivities := true;
        ShowSalesActivities := true;
        ShowPurchasesActivities := true;
        ShowPaymentsActivities := true;
        ShowIncomingDocuments := true;
        ShowAwaitingIncomingDoc := OCRServiceMgt.OcrServiceIsEnable;

        RoleCenterNotificationMgt.ShowNotifications;
    end;

    var
        ActivitiesMgt: Codeunit "Activities Mgt.";
        CueSetup: Codeunit "Cues And KPIs";
        O365GettingStartedMgt: Codeunit "O365 Getting Started Mgt.";
        [RunOnClient]
        [WithEvents]
        CameraProvider: dotnet CameraProvider;
        [RunOnClient]
        [WithEvents]
        UserTours: dotnet UserTours;
        [RunOnClient]
        [WithEvents]
        PageNotifier: dotnet PageNotifier;
        HasCamera: Boolean;
        ShowCamera: Boolean;
        ShowDocumentsPendingDocExchService: Boolean;
        ShowStartActivities: Boolean;
        ShowIncomingDocuments: Boolean;
        ShowPaymentsActivities: Boolean;
        ShowPurchasesActivities: Boolean;
        ShowSalesActivities: Boolean;
        ShowAwaitingIncomingDoc: Boolean;
        TileGettingStartedVisible: Boolean;
        ReplayGettingStartedVisible: Boolean;

    local procedure CalculateCueFieldValues()
    begin
        if FieldActive("Overdue Sales Invoice Amount") then
          "Overdue Sales Invoice Amount" := ActivitiesMgt.CalcOverdueSalesInvoiceAmount;
        if FieldActive("Overdue Purch. Invoice Amount") then
          "Overdue Purch. Invoice Amount" := ActivitiesMgt.CalcOverduePurchaseInvoiceAmount;
        if FieldActive("Sales This Month") then
          "Sales This Month" := ActivitiesMgt.CalcSalesThisMonthAmount;
        if FieldActive("Top 10 Customer Sales YTD") then
          "Top 10 Customer Sales YTD" := ActivitiesMgt.CalcTop10CustomerSalesRatioYTD;
        if FieldActive("Average Collection Days") then
          "Average Collection Days" := ActivitiesMgt.CalcAverageCollectionDays;
    end;

    local procedure SetActivityGroupVisibility()
    var
        StartActivitiesMgt: Codeunit "Top Customers By Sales Job";
        SalesActivitiesMgt: Codeunit "Sales Activities Mgt.";
        PurchasesActivitiesMgt: Codeunit "Trial Balance Cache Mgt.";
        PaymentsActivitiesMgt: Codeunit "Template Feature Mgt.";
        IncDocActivitiesMgt: Codeunit "Inc. Doc. Activities Mgt.";
    begin
        ShowStartActivities := StartActivitiesMgt.IsActivitiesVisible;
        ShowSalesActivities := SalesActivitiesMgt.IsActivitiesVisible;
        ShowPurchasesActivities := PurchasesActivitiesMgt.IsActivitiesVisible;
        ShowPaymentsActivities := PaymentsActivitiesMgt.IsActivitiesVisible;
        ShowIncomingDocuments := IncDocActivitiesMgt.IsActivitiesVisible;
        ShowCamera := HasCamera and ShowIncomingDocuments;
    end;

    trigger Cameraprovider::PictureAvailable(PictureName: Text;PictureFilePath: Text)
    var
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument.CreateIncomingDocumentFromServerFile(PictureName,PictureFilePath);
        CurrPage.Update;
    end;

    trigger Usertours::ShowTourWizard(hasTourCompleted: Boolean)
    begin
        O365GettingStartedMgt.LaunchWizard(false,hasTourCompleted);
    end;

    trigger Usertours::IsTourInProgressResultReady(isInProgress: Boolean)
    begin
    end;

    trigger Pagenotifier::PageReady()
    var
        O365GettingStarted: Record "O365 Getting Started";
        PermissionManager: Codeunit "Permission Manager";
        WizardHasBeenShownToUser: Boolean;
    begin
        if not (CurrentClientType in [Clienttype::Tablet,Clienttype::Phone]) then
          exit;

        if not PermissionManager.SoftwareAsAService then
          exit;

        WizardHasBeenShownToUser := O365GettingStarted.Get(UserId,CurrentClientType);
        if not WizardHasBeenShownToUser then
          Page.RunModal(Page::"O365 Getting Started Device");
    end;
}

