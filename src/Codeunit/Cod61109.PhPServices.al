#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 61109 PhPServices
{
    // RESERVEIDs,CONFIRMATIONCODEs,TRANSDATEs,ROOMIDs,CHECKINs,
    // CHECKOUTs,AMOUNTs,GUESTIDs,RECEIVINGBANKs,
    // TRANSIDs,STATUSes,ROOMNUMs,CONFIRMATIONDATEs,
    // ISREFUNDABLEs,REFUNDABLEDAYS1,UNITCOSTs,TOTALREFUNDs,DAYS1,
    // Operation,CancelationReason,ConfirmedBy,CheckinBy,
    // CancelledBy,CheckoutBy,ReleasedBy,ConfirmedDateTime,
    // CheckinDateTime,CancelledDateTime,CheckoutDateTime,ReleasedDateTime,Plan


    trigger OnRun()
    var
        tblreservations: Record UnknownRecord75024;
    begin
        //CreateGuest(1222,'154 Kimilili','00100','Kimilili','AppKings',
        // // 'Wanjala','Tinga',100025,'12345','wanjala','12/12/1983',
        // // 'Kenyan','0704121064','wanjala@gmail.com','CREATE',24498728);
        // // // // // // // // // //  MESSAGE(CreateReservation(35,'K3KSCKP3','',2,'','',252000,27,'KCB','33667721',
        // // // // // // // // // //  'CHECKEDOUT',2,'02/04/2020',TRUE,22,9000,252000,22,'UPDATE',
        // // // // // // // // // //  '','WANJALA','WANJALA',
        // // // // // // // // // //  '','','','','','','02/04/2020','',''));
        // // // //  tblreservations.RESET;
        // // // //  tblreservations.SETRANGE(CONFIRMATIONCODE,'Q6QBK8GF');
        // // // //  IF tblreservations.FIND('-') THEN CreateAndPostInvoice(tblreservations);
          //  Post_POS_Orders(470,'ITEM-00446',4,'0033','11',0);
        // //    Post_POS_Orders(421,'ITEM-00528',2,'0033','9',0);
        // //    Post_POS_Orders(421,'ITEM-00527',2,'0033','9',0);
        // //
        // //    Post_POS_Orders(411,'ITEM-00446',3,'0034','9',0);
        // //    Post_POS_Orders(411,'ITEM-00528',3,'0034','9',0);
        // //    Post_POS_Orders(411,'ITEM-00527',3,'0034','9',0);
    end;


    procedure CreateGuest(GID: Integer;GADDRESS: Code[150];GCAddress: Code[150];GCity: Code[150];GCompany: Code[150];GFmane: Code[150];GLName: Code[150];GZip: Integer;GPass: Text[150];GUname: Text[150];GDoB: Code[100];GNationality: Code[150];GPhone: Code[150];GEmail: Text;Operation: Code[10];ID_NO: Code[20]) Success: Code[10]
    var
        tblguest: Record UnknownRecord75023;
        DateEval: Date;
        Customer: Record Customer;
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        /*CLEAR(DateEval);
        CLEAR(Success);
        Success:='FAIL';
        //Check if Guest as a Customer Exists and create if not
        Customer.RESET;
        Customer.SETRANGE("No.",FORMAT(ID_NO));
        IF NOT Customer.FIND('-') THEN BEGIN
          GeneralLedgerSetup.RESET;
          IF GeneralLedgerSetup.FIND('-') THEN BEGIN
            GeneralLedgerSetup.TESTFIELD("Hotel Cus. Booking Posting G.");
            END;
            Customer.INIT;
            Customer."No.":=FORMAT(ID_NO);
            Customer."Customer Posting Group":=GeneralLedgerSetup."Hotel Cus. Booking Posting G.";
            Customer."Gen. Bus. Posting Group":='LOCAL';
            Customer."Phone No.":=GPhone;
            Customer."E-Mail":=GEmail;
            Customer.Address:=GADDRESS;
            Customer.Name:=GFmane+' '+GLName;
            Customer.INSERT;
            //Customer."Date Of Birth"
          END ELSE BEGIN
            //Update
            END;
        
        IF EVALUATE(DateEval,GDoB) THEN;
        IF Operation='CREATE' THEN BEGIN
        tblguest.INIT;
        tblguest.GUESTID:=GID;
        tblguest.G_LNAME:=GLName;
        tblguest.G_CITY:=GCity;
        tblguest.G_ADDRESS:=GADDRESS;
        tblguest.DBIRTH:=GDoB;
        tblguest.G_PHONE:=GPhone;
        tblguest.G_NATIONALITY:=GNationality;
        tblguest.G_COMPANY:=GCompany;
        tblguest.G_CADDRESS:=GCAddress;
        tblguest.G_FNAME:=GFmane;
        tblguest.G_EMAIL:=GEmail;
        tblguest.G_UNAME:=GUname;
        tblguest.G_PASS:=GPass;
        tblguest.IDNO:=ID_NO;
        tblguest.ZIP:=GZip;
        IF tblguest.INSERT THEN;
        END ELSE BEGIN
          tblguest.RESET;
          tblguest.SETRANGE(GUESTID,GID);
          IF tblguest.FIND('-') THEN BEGIN
            IF GLName<>'' THEN
        tblguest.G_LNAME:=GLName;
            IF GCity<>'' THEN
        tblguest.G_CITY:=GCity;
            IF GADDRESS<>'' THEN
        tblguest.G_ADDRESS:=GADDRESS;
            IF GDoB<>'' THEN
        tblguest.DBIRTH:=GDoB;
            IF GPhone<>'' THEN
        tblguest.G_PHONE:=GPhone;
            IF GNationality<>'' THEN
        tblguest.G_NATIONALITY:=GNationality;
            IF GCompany<>'' THEN
        tblguest.G_COMPANY:=GCompany;
            IF GCAddress<>'' THEN
        tblguest.G_CADDRESS:=GCAddress;
            IF GFmane<>'' THEN
        tblguest.G_FNAME:=GFmane;
            IF GEmail<>'' THEN
        tblguest.G_EMAIL:=GEmail;
            IF GUname<>'' THEN
        tblguest.G_UNAME:=GUname;
            IF ID_NO<>'' THEN
        tblguest.IDNO:=ID_NO;
            IF GPass<>'' THEN
        tblguest.G_PASS:=GPass;
            IF GZip<>0 THEN
        tbluest.ZIP:=GZip;
        IF tblguest.MODIFY THEN;
        END;
          END;
        Success:='SUCCESSFUL';
        */

    end;


    procedure CreateRoom(ACCOMMODID: Code[50];ROOMNAMES: Code[150];ROOMDESCRIPTION: Code[150];NUMPERSONS: Integer;PRICES: Decimal;Operation: Code[10];full_Board: Decimal;half_Boar: Decimal) Success: Code[10]
    var
        tblRooms: Record UnknownRecord75022;
        DateEval: Date;
    begin
        /*IF Operation='CREATE' THEN BEGIN
        tblRooms.INIT;
        tblRooms.ACCOMID:=ACCOMMODID;
        tblRooms.ROOMNAME:=ROOMNAMES;
        tblRooms.ROOMDESC:=ROOMDESCRIPTION;
        tblRooms.NUMPERSON:=NUMPERSONS;
        tblRooms.PRICE:=PRICES;
        tblRooms."Full Board":=full_Board;
        tblRooms."Half Board":=half_Boar;
        IF tblRooms.INSERT THEN;
        END ELSE BEGIN
          tblRooms.RESET;
          tblRooms.SETRANGE(ACCOMID,ACCOMMODID);
          tblRooms.SETRANGE(ROOMNAME,ROOMNAMES);
          IF tblRooms.FIND('-') THEN BEGIN
            IF ROOMDESCRIPTION<>'' THEN
        tblRooms.ROOMDESC:=ROOMDESCRIPTION;
            IF NUMPERSONS<>0 THEN
        tblRooms.NUMPRSON:=NUMPERSONS;
        tblRooms.PRICE:=PRICES;
        IF tblRooms.MODIFY THEN;
        END;
          END;
        */

    end;


    procedure CreateReservation(RESERVEIDs: Integer;CONFIRMATIONCODEs: Code[150];TRANSDATEs: Code[150];ROOMIDs: Integer;CHECKINs: Code[100];CHECKOUTs: Code[100];AMOUNTs: Decimal;GUESTIDs: Integer;RECEIVINGBANKs: Code[150];TRANSIDs: Text[150];STATUSes: Code[100];ROOMNUMs: Integer;CONFIRMATIONDATEs: Code[150];ISREFUNDABLEs: Boolean;REFUNDABLEDAYS1: Integer;UNITCOSTs: Decimal;TOTALREFUNDs: Decimal;DAYS1: Integer;Operation: Code[10];CancelationReason: Text[250];ConfirmedBy: Code[20];CheckinBy: Code[20];CancelledBy: Code[20];CheckoutBy: Code[20];ReleasedBy: Code[20];ConfirmedDateTime: Code[20];CheckinDateTime: Code[20];CancelledDateTime: Code[20];CheckoutDateTime: Code[20];ReleasedDateTime: Code[20];Plan: Code[20];AMOUNTs2: Decimal) Success: Code[20]
    var
        tblreservation: Record UnknownRecord75024;
        DateEval: Date;
        CHECKINsDates: Date;
        CHECKOUTsDates: Date;
        CONFIRMATIONDATEs1: Date;
        SalesHeader: Record "Sales Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        FINPaymentLine: Record UnknownRecord61705;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NextPVNo: Code[20];
        FINPaymentsHeader: Record UnknownRecord61688;
        tblguest: Record UnknownRecord75023;
        RecExists: Boolean;
        CreditMemoNo: Code[20];
    begin
        /*CLEAR(DateEval);
        CLEAR(CHECKINsDates);
        CLEAR(CHECKOUTsDates);
        CLEAR(CONFIRMATIONDATEs1);
        CLEAR(Success);
        Success:='FAILED';
        IF EVALUATE(DateEval,TRANSDATEs) THEN;
        IF EVALUATE(CHECKINsDates,CHECKINs) THEN;
        IF EVALUATE(CHECKOUTsDates,CHECKOUTs) THEN;
        IF EVALUATE(CONFIRMATIONDATEs1,CONFIRMATIONDATEs) THEN;
        //IF DateEval=0D THEN DateEval:=TODAY;
        //IF CHECKINsDates=0D THEN CHECKINsDates:=TODAY;
        //IF CHECKOUTsDates=0D THEN CHECKOUTsDates:=TODAY;
        //IF CONFIRMATIONDATEs1=0D THEN CONFIRMATIONDATEs1:=TODAY;
        
          tblreservation.RESET;
          tblreservation.SETRANGE(CONFIRMATIONCODE,CONFIRMATIONCODEs);
          IF NOT (tblreservation.FIND('-')) THEN BEGIN
        
        IF Operation='CREATE' THEN BEGIN
        tblreservation.INIT;
        tblreservation.RESERVEID:=RESERVEIDs;
        tblreservation.CONFIRMATIONCODE:=CONFIRMATIONCODEs;
        tblreservation.TRANSDATE:=TRANSDATEs;
        tblreservation.ROOMID:=ROOMIDs;
        tblreservation.CHECKIN:=CHECKINs;
        tblreservation.CHECKOUT:=CHECKOUTs;
        tblreservation.AMOUNT:=AMOUNTs;
        tblreservation.GUESTID:=GUESTIDs;
        tblreservation.RECEIVINGBANK:=RECEIVINGBANKs;
        tblreservation.TRANSID:=TRANSIDs;
        tblreservation.STATUS:=STATUSes;
        tblreservation.ROOMNUM:=ROOMNUMs;
        tblreservation.CONFIRMATIONDATE:=CONFIRMATIONDATEs;
        tblreservation.ISREFUNDABLE:=ISREFUNDABLEs;
        tblreservation.REFUNDABLEDAYS:=REFUNDABLEDAYS1;
        tblreservation.UNITCOST:=UNITCOSTs;
        tblreservation.TOTALREFUND:=TOTALREFUNDs;
        tblreservation.DAYS:=DAYS1;
        tblreservation."Cancelation Reason":=CancelationReason;
        tblreservation."Confirmed By":=ConfirmedBy;
        tblreservation."Payment Plan":=Plan;
        tblreservation."Discount Amount":=AMOUNTs2;
        tblreservation."Confirmed Date Time":=CREATEDATETIME(TODAY,TIME);
        IF tblreservation.INSERT THEN;
        END;
        END ELSE BEGIN
        BEGIN
          CLEAR(RecExists);
          tblreservation.RESET;
          tblreservation.SETRANGE(CONFIRMATIONCODE,CONFIRMATIONCODEs);
          IF tblreservation.FIND('-') THEN BEGIN
            IF (tblreservation.STATUS=STATUSes) THEN RecExists:=TRUE;
            IF RESERVEIDs<>0 THEN
        tblreservation.RESERVEID:=RESERVEIDs;
        // //    IF CONFIRMATIONCODEs<>'' THEN
        // // tblreservation.CONFIRMATIONCODE:=CONFIRMATIONCODEs;
            IF TRANSDATEs<>'' THEN
        tblreservation.TRANSDATE:=TRANSDATEs;
            IF ROOMIDs<>0 THEN
        tblreservation.ROOMID:=ROOMIDs;
             IF CHECKINs<>'' THEN
        tblreservation.CHECKIN:=CHECKINs;
             IF CHECKOUTs<>'' THEN
        tblreservation.CHECKOUT:=CHECKOUTs;
             IF AMOUNTs<>0 THEN
        tblreservation.AMOUNT:=AMOUNTs;
             IF GUESTIDs<>0 THEN
        tblreservation.GUESTID:=GUESTIDs;
             IF RECEIVINGBANKs<>'' THEN
        tblreservation.RECEIVINGBANK:=RECEIVINGBANKs;
             IF TRANSIDs<>'' THEN
        tblreservation.TRANSID:=TRANSIDs;
        IF STATUSes<>'' THEN
        tblreservation.STATUS:=STATUSes;
        IF ROOMNUMs<>0 THEN
        tblreservation.ROOMNUM:=ROOMNUMs;
        IF CONFIRMATIONDATEs<>'' THEN
        tblreservation.CONFIRMATIONDATE:=CONFIRMATIONDATEs;
        IF ISREFUNDABLEs<>FALSE THEN
        tblreservation.ISREFUNDABLE:=ISREFUNDABLEs;
        IF REFUNDABLEDAYS1<>0 THEN
        tblreservation.REFUNDABLEDAYS:=REFUNDABLEDAYS1;
        IF UNITCOSTs<>0 THEN
        tblreservation.UNITCOST:=UNITCOSTs;
        IF TOTALREFUNDs<>0 THEN
        tblreservation.TOTALREFUND:=TOTALREFUNDs;
        IF DAYS1<>0 THEN
        tblreservation.DAYS:=DAYS1;
        IF ConfirmedBy <>'' THEN
          tblreservation."Confirmed By":=ConfirmedBy;
        IF CheckinBy <>'' THEN
        tblreservation."Checked In By":=CheckinBy;
        IF CancelledBy <>'' THEN
        tblreservation."Cancelled By":=CancelledBy;
        IF CheckoutBy <>'' THEN
        tblreservation."Checkout By":=CheckoutBy;
        IF Plan<>'' THEN
        tblreservation."Payment Plan":=Plan;
        IF ReleasedBy <>'' THEN
        tblreservation."Released By":=ReleasedBy;
        IF AMOUNTs2>0 THEN
          tblreservation."Discount Amount":=AMOUNTs2;
        
        
          // ....................
        IF ConfirmedDateTime <>'' THEN
          tblreservation."Confirmed Date Time":=CREATEDATETIME(TODAY,TIME);
        IF CheckinDateTime <>'' THEN
          tblreservation."Checked In  Date Time":=CREATEDATETIME(TODAY,TIME);
        IF CancelledDateTime <>'' THEN
          tblreservation."Cancelled  Date Time":=CREATEDATETIME(TODAY,TIME);
        IF CheckoutDateTime <>'' THEN
          tblreservation."Checkout  Date Time":=CREATEDATETIME(TODAY,TIME);
        IF ReleasedDateTime <>'' THEN
          tblreservation."Released  Date Time":=CREATEDATETIME(TODAY,TIME);
        IF CancelationReason<>'' THEN
        tblreservation."Cancelation Reason":=CancelationReason;
        IF tblreservation.MODIFY THEN;
        END;
        END;
          END;
        
        IF RecExists=FALSE THEN BEGIN
        IF STATUSes='CONFIRMED' THEN BEGIN
          CreateOrder(CONFIRMATIONCODEs);
          END ELSE IF STATUSes='CANCELLED' THEN BEGIN
            //Archive The Document
            SalesHeader.RESET;
            SalesHeader.SETRANGE(SalesHeader."Document Type",SalesHeader."Document Type"::Order);
            SalesHeader.SETRANGE(SalesHeader."No.",tblreservation."LPO No.");
              IF SalesHeader.FIND('-') THEN BEGIN
            ArchiveManagement.ArchiveSalesDocument(SalesHeader);
                SalesHeader.Status:=SalesHeader.Status::"4";
                SalesHeader.MODIFY;
                END;
          END  ELSE IF STATUSes='CHECKEDIN' THEN BEGIN
            // Post the LPO and Invoice
            CreateAndPostInvoice(tblreservation);
          END  ELSE IF STATUSes='CHECKEDOUT' THEN BEGIN
            //If Refund exists then Create a PV for refund
            IF REFUNDABLEDAYS1>0 THEN BEGIN
              CLEAR(CreditMemoNo);
              IF SalesReceivablesSetup.GET THEN BEGIN
              CreditMemoNo:=NoSeriesManagement.GetNextNo(SalesReceivablesSetup."Credit Memo Nos.",TODAY,TRUE);
              tblreservation."Credit Note No.":=CreditMemoNo;
              tblreservation."Credit No":=CreditMemoNo;
              CreateCreditMemo(tblreservation,CreditMemoNo);
              END;
              tblguest.RESET;
              tblguest.SETRANGE(GUESTID,tblreservation.GUESTID);
              IF tblguest.FIND('-') THEN;
              CLEAR(NextPVNo);
              IF SalesReceivablesSetup.GET THEN NextPVNo:=NoSeriesManagement.GetNextNo(SalesReceivablesSetup."Room Book. Reversal PV",TODAY,TRUE);
              SalesReceivablesSetup.TESTFIELD("Room Refund Payment Type");
              SalesReceivablesSetup.TESTFIELD("Room Booking G/L Account");
                FINPaymentsHeader.INIT;
                FINPaymentsHeader."Payment Type":=FINPaymentsHeader."Payment Type"::Normal;
                FINPaymentsHeader."No.":=NextPVNo;
                FINPaymentsHeader.Date:=TODAY;
                FINPaymentsHeader.Payee:=tblguest.G_FNAME+' '+tblguest.G_LNAME;
                FINPaymentsHeader."On Behalf Of":='KISUMU HOTEL';
                FINPaymentsHeader."Payment Narration":='Refund: Ref:'+CONFIRMATIONCODEs+', Receipt: '+tblreservation."Booking Receipt No"+
                    ' Days: '+FORMAT(tblreservation.REFUNDABLEDAYS)+' @'+FORMAT(tblreservation.UNITCOST);
                FINPaymentsHeader.Status:=FINPaymentsHeader.Status::Pending;
                FINPaymentsHeader."Is Room Booking Refund":=TRUE;
                FINPaymentsHeader.INSERT;
                //Insert Lines
                FINPaymentLine.INIT;
                FINPaymentLine."Line No.":=1000;
                FINPaymentLine.VALIDATE(FINPaymentLine.Type,SalesReceivablesSetup."Room Refund Payment Type");
                FINPaymentLine.No:=NextPVNo;
                FINPaymentLine.VALIDATE(FINPaymentLine."Account No.",FORMAT(tblguest.IDNO));
                FINPaymentLine."Transaction Name":='Refund: Ref:'+CONFIRATIONCODEs+', Receipt: '+tblreservation."Booking Receipt No"+
                    ' Days: '+FORMAT(tblreservation.REFUNDABAYS)+' @'+FORMAT(tblreservation.UNITCOST);
                FINPaymentLine.Amount:=tblreservation.UNITCOST*tblreservation.REFUNDABLEDAYS;
                FINPaymentLine."Net Amount":=tblreservation.UNITCOST*tblreservation.REFUNDABLEDAYS;
                FINPaymentLine.INSERT;
                tblreservation."Reversal PV No.":=NextPVNo;
                tblreservation.MODIFY;
              END;
          END;
          END;
          //-Confirm Reservation - Create an Ivoice
          //-Cancel Reservation - Cancel Document for Invoice,
        Success:='SUCCESS';
        */

    end;


    procedure CreateAccommodation(CATEGORYNAMEs: Code[150];DESCRIPTIONs: Code[150];Operation: Code[10]) Success: Code[10]
    var
        tblroomcategories: Record UnknownRecord75025;
        DateEval: Date;
    begin
        /*CLEAR(DateEval);
        //IF EVALUATE(DateEval,GDoB) THEN;
        IF Operation='CREATTHEN BEGIN
        tblroomcategories.INIT;
        tblroomcategories.CATEGORYNAME:=CATEGORYNAMEs;
        tblroomcategories.DESCRIPTION:=DESCRIPTIONs;
        IF tblroomcategories.INSERT THEN;
        END ELSE BEGIN
          tblroomcategories.RESET;
          tblroomcategories.SETRANGE(CATEGORYNAME,CATEGORYNAMEs);
          IF tblroomcategories.FIND('-') THEN BEGIN
            IF DESCRIPTIONs<>'' THEN
        tblroomcategories.DESCRIPTION:=DESCRIPTIONs;
        IF tblroomcategories.MODIFY THEN;
        END;
          END;
          */

    end;


    procedure CreateRoomNumber(ROOMNUMs: Integer;ROOMNAMEs: Text;ACCOMTYPEs: Code[150];STATUSes: Code[150];CONFIRMATIONIDs: Text[150];Operation: Code[10]) Success: Code[10]
    var
        tblroomnum: Record UnknownRecord75020;
        DateEval: Date;
    begin
        /*CLEAR(DateEval);
        //IF EVALUATE(DateEval,GDoB) THEN;
        IF Operation='CREATE' THEN IN
        tblroomnum.INIT;
        tblroomnum.ROOMNUM:=ROOMNUMs;
        tblroomnROOMNAME:=ROOMNAMEs;
        tblroomnum.ACCOMTYPE:=ACCOMTYPEs;
        tblroomnum.STATUS:=STATUSes;
        tblroomnum.CONFIRMATIONID:=CONFIRMATIONIDs;
        IF tblroomnum.INSERT THEN;
        END ELSE BEGIN
          tblroomnum.RSET;
          tblroomnum.SETRANGE(ROOMNUM,ROOMs);
          IF tblroomnum.FIND('-') THEN BEGIN
            IF ROOMNAMEs<>'' THEN
        tblroomnum.ROOMNAME:=ROOMNAMEs;
            IF ACCOMTYPEs<>'' THEN
        tblroomnum.ACCOMTYPE:=ACCOMTYPEs;
            IF STATUSes<>'' THEN
        tblroomnum.STATUS:=STATUSes;
        tblroomnum.CONFIRMATIONID:=CONFIRMATIONIDs;
        IF tblroomnum.MODIFY THEN;
        END;
          END;
          */

    end;


    procedure ValidateAccount(PassIdNo: Code[20]) Response: Text[250]
    var
        tblguest: Record UnknownRecord75023;
    begin
        /*CLEAR(Response);
        tblguest.RESET;
        tblguest.SETRANGE(IDNO,PassIdNo);
        IF tblguest.FIND('-') THEN BEGIN
            Response:='User Name: '+tblguest.G_UNAME+', Password: '+tblguest.G_PASS;
          END;
        */

    end;

    local procedure CreateOrder(RefNo: Code[20])
    var
        tblreservation: Record UnknownRecord75024;
        lineNo: Integer;
        DateFilter: Date;
        NextOderNo: Code[20];
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        CurrExchRate: Record "Currency Exchange Rate";
        SalesCommentLine: Record "Sales Comment Line";
        PostCode: Record "Post Code";
        BankAcc: Record "Bank Account";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesInvHeaderPrepmt: Record "Sales Invoice Header";
        SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        RespCenter: Record "Responsibility Center";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        WhseRequest: Record "Warehouse Request";
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry";
        CompanyInfo: Record "Company Information";
        UserSetupMgt: Codeunit "User Setup Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WhseSourceHeader: Codeunit "Whse. Validate Source Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        FINCashOfficeUserTemplate: Record UnknownRecord61712;
        Customer: Record Customer;
        Item: Record Item;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocumentIsPosted: Boolean;
        ExternalDocNoMandatory: Boolean;
    begin
        /*tblreservation.RESET;
        tblreservation.SETRANGE(CONFIRMATIONCODE,RefNo);
        IF tblreservation.FIND('-') THEN tblreservation.CALCFIELDS("Guest ID No.");
        IF tblreservation.DAYS=0 THEN tblreservation.DAYS:=1;
        CLEAR(NextOderNo);
        IF Customer.GET(tblreservation."Guest ID No.") THEN BEGIN
        IF SalesSetup.GET() THEN SalesSetup.TESTFIELD("Order Nos.");
        NextOderNo:=NoSeriesMgt.GetNextNo(SalesSetup."Order Nos.",TODAY,TRUE);
        SalesHeader.INIT;
        SalesHeader."Document Type":=SalesHeader."Document Type"::Order;
        SalesHeader."No.":=NextOderNo;
        SalesHeader."Sell-to Customer No.":=Customer."No.";
        SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.");
        SalesHeader."Bill-to Customer No.":=Customer."No.";
        SalesHeader.VALIDATE(SalesHeader."Bill-to Customer No.");
        SalesHeader."Document Date":=TODAY;
        SalesHeader."Posting Date":=TODAY;
        SalesHeader."Posting Description":=COPYSTR('Accommodation Booking-'+SalesHeader."Sell-to Customer Name",1,50);
        SalesHeader."Order Date":=TODAY;
        SalesHeader."Due Date":=TODAY;
        SalesHeader."Location Code":='HOTEL';
        SalesHeader.VALIDATE("Location Code");
        SalesHeader.VALIDATE("Shipping No. Series",SalesSetup."Posted Shipment Nos.");
        SalesHeader."Is a Room Booking":=TRUE;
        SalesHeader.INSERT(TRUE);
        
        lineNo:=0;
            lineNo:=lineNo+100;
        SalesLine.INIT;
        SalesLine."Document Type":=SalesLine."Document Type"::Order;
        SalesLine."Document No.":=NextOderNo;
        SalesLine."Line No.":=lineNo;
        SalesLine.Type:=SalesLine.Type::"G/L Account";
        SalesLine."No.":=SalesSetup."Room Booking G/L Account";
        SalesLine.VALIDATE("No.");
        SalesLine."Location Code":='HOTEL';
        SalesLine."Unit Price":=tblreservation.UNITCOST;
        
        SalesLine.VALIDATE("Location Code");
        SalesLine.Quantity:=tblreservation.DAYS;
        SalesLine.VALIDATE(Quantity);
        //SalesLine."Line Discount Amount":=tblreservation."Discount Amount";
        //SalesLine.VALIDATE("Line Discount Amount");
        
        SalesLine."Qty. to Ship":=tblreservation.DAYS;
        SalesLine."Qty. to Invoice":=tblreservation.DAYS;
        SalesLine."Planned Delivery Date":=TODAY;
        SalesLine."Gen. Bus. Posting Group":='LOCAL';
        SalesLine."Gen. Prod. Posting Group":='HOTEL';
        //SalesLine."VAT Bus. Posting Group":=Item.v
        //SalesLine."VAT Prod. Posting Group":Item."VAT Prod. Posting Group";
        SalesLine."Planned Shipment Date":DAY;
        //SalesLine.VALIDATE(Quantity);
        //SalesLine.VALIDATE("No.");
        //SalesLine.VALIDATE("Location Code");
        
        tblreservation."LPO No.":=NextOderNo;
        tblreservation.MODIFY;
        
        SalesLine.INSERT(TRUE);
        
        
        //Set The Order Status as  released then post
        SalesHeader.RESET;
        SalesHeader.SETRANGE(SalesHeader."Document Type",SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE(SalesHeader."No.",NextOderNo);
        IF SalesHeader.FIND('-') THEN BEGIN
          SalesHeader.Status:=SalesHeader.Status::Released;
          SalesHeader.MODIFY;
          END;
          END;
          */

    end;

    local procedure CreateAndPostInvoice(tblreservation2: Record UnknownRecord75024)
    var
        tblreservation: Record UnknownRecord75024;
        lineNo: Integer;
        DateFilter: Date;
        NextOderNo: Code[20];
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        CurrExchRate: Record "Currency Exchange Rate";
        SalesCommentLine: Record "Sales Comment Line";
        PostCode: Record "Post Code";
        BankAcc: Record "Bank Account";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesInvHeaderPrepmt: Record "Sales Invoice Header";
        SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        RespCenter: Record "Responsibility Center";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        WhseRequest: Record "Warehouse Request";
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry";
        CompanyInfo: Record "Company Information";
        UserSetupMgt: Codeunit "User Setup Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WhseSourceHeader: Codeunit "Whse. Validate Source Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        FINCashOfficeUserTemplate: Record UnknownRecord61712;
        Customer: Record Customer;
        Item: Record Item;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocumentIsPosted: Boolean;
        ExternalDocNoMandatory: Boolean;
    begin
        /*NextOderNo:=tblreservation2."LPO No.";
        //Set The Order Status as Posted and released then post
        SalesHeader.RESET;
        SalesHeader.SETRANGE(SalesHeader."Document Type",SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE(SalesHeader."No.",NextOderNo);
        IF SalesHeader.FIND('-') THEN
          //Post the order Here...
        CODEUNIT.RUN(81,SalesHeader);
        // Get and populate The Invoice ande shipment Numbers Here...
        SalesInvoiceHeader.RESET;
        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Order No.",NextOderNo);
        IF SalesInvoiceHeader.FIND('-') THEN BEGIN
          tblreservation2."Invoice No.":=SalesInvoiceHeader."No.";
          END;
        
        SalesShipmentHeader.RESET;
        SalesShipmentHeader.SETRANGE(SalesShipmentHeader."Order No.",NextOderNo);
        IF SalesShipmentHeader.FIND('-') THEN BEGIN
          tblreservation2."Shipment No.":=SalesShipmentHeader."No.";
          END;
          tblreservation2.MODIFY;
          */

    end;

    local procedure RefundOnINvoiceAndReceipt()
    begin
    end;

    local procedure CreateCreditMemo(tblreservation2: Record UnknownRecord75024;CreditMemoNoz: Code[20])
    var
        lineNo: Integer;
        DateFilter: Date;
        NextOderNo: Code[20];
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        CurrExchRate: Record "Currency Exchange Rate";
        SalesCommentLine: Record "Sales Comment Line";
        PostCode: Record "Post Code";
        BankAcc: Record "Bank Account";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesInvHeaderPrepmt: Record "Sales Invoice Header";
        SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        RespCenter: Record "Responsibility Center";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        WhseRequest: Record "Warehouse Request";
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry";
        CompanyInfo: Record "Company Information";
        UserSetupMgt: Codeunit "User Setup Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WhseSourceHeader: Codeunit "Whse. Validate Source Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        FINCashOfficeUserTemplate: Record UnknownRecord61712;
        Customer: Record Customer;
        Item: Record Item;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocumentIsPosted: Boolean;
        ExternalDocNoMandatory: Boolean;
        tblreservation5: Record UnknownRecord75024;
    begin
        /*// // tblreservation.RESET;
        // // tblreservation.SETRANGE(CONFIRMATIONCODE,RefNo);
        // // IF tblreservation2.FIND('-') THEN
        tblreservation5.COPYFILTERS(tblreservation2);
          tblreservation2.CALCFIELDS("Guest ID No.");
        CLEAR(NextOderNo);
        IF Customer.GET(tblreservation2."Guest ID No.") THEN BEGIN
        IF SalesSetup.GET() THEN SalesSetup.TESTFIELD("Credit Memo Nos.");
        NextOderNo:=CreditMemoNoz;
        // IF tblreservation5.FIND('-') THEN BEGIN
        // tblreservation5."Credit No":=NextOderNo;
        // tblreservation5.MODIFY;
        // END;
        SalesHeader.INIT;
        SalesHeader."Document Type":=SalesHeader."Document Type"::"Credit Memo";
        SalesHeader."No.":=NextOderNo;
        SalesHeader."Sell-to Customer No.":=Customer."No.";
        SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.");
        SalesHeader."Bill-to Customer No.":=Customer."No.";
        SalesHeader.VALIDATE(SalesHeader."Bill-to Customer No.");
        SalesHeader."Document Date":=TODAY;
        SalesHeader."Posting Date":=TODAY;
        SalesHeader."Posting Description":=COPYSTR('Credit on Accommodation Booking-'+SalesHeader."Sell-to Customer Name",1,50);
        SalesHeader."Order Date":=TODAY;
        SalesHeader."Due Date":=TODAY;
        SalesHeader."Location Code":='HOTEL';
        SalesHeader.VALIDATE("Location Code");
        SalesHeader.VALIDATE("Shipping No. Series",SalesSetup."Posted Shipment Nos.");
        SalesHeader."Is a Room Booking":=TRUE;
        SalesHeader.INSERT(TRUE);
        
        lineNo:=0;
            lineNo:=lineNo+100;
        SalesLine.INIT;
        SalesLine."Document Type":=SalesLine."Document Type"::"Credit Memo";
        SalesLine."Document No.":=NextOderNo;
        SalesLine."Line No.":=lineNo;
        SalesLine.Type:=SalesLine.Type::"G/L Account";
        SalesLine."No.":=SalesSetup."Room Booking G/L Account";
        SalesLine.VALIDATE("No.");
        SalesLine."Location Code":='HOTEL';
        SalesLine."Unit Price":=tblreservation2.UNITCOST;
        SalesLine.VALIDATE("Location Code");
        SalesLine.Quantity:=tblreservation2.REFUNDABLEDAYS;
        SalesLine.VALIDATE(Quantity);
        //SalesLine."Qty. to Ship":=tblreservation.REFUNDABLEDAYS;
        //SalesLine."Qty. to Invoice":=tblreservation.REFUNDABLEDAYS;
        SalesLine."Planned Delivery Date":=TODAY;
        SalesLine."Gen. Bus. Posting Group":='LOCAL';
        SalesLine."Gen. Prod. Posting Group":='HOTEL';
        //SalesLine."VAT Bu. Posting Group":=Item.v
        //SalesLine."VAT Prod. Posting Group":=Item."VAT Prod. Posting Group";
        SalesLine."Planned Shipment Date":=TODAY;
        //SalesLine.VALIDATE(Quantity);
        //SalesLine.VALIDATE("No.");
        //SalesLine.VALIDATE("Location Code");
        
        SalesLine.INSERT(TRUE);
        
        
        //Set The Order Status as  released then post
        SalesHeader.RESET;
        SalesHeader.SETRANGE(SalesHeader."Document Type",alesHeader."Document Type"::"Credit Memo");
        SalesHeader.SETRANGE(SalesHeader."No.",NextOderNo);
        IF SalesHeader.FIND('-') THEN BEGIN
          SalesHeader.Status:=SalesHeader.Status::Released;
          SalesHeader.MODIFY;
         END;
          END;
        */

    end;


    procedure GetHotelOrderProfInvNos(DocTypw: Option POSOerder,LPO,INVOICE) OrderProfInVNo: Integer
    var
        FOODOrderBatchLines: Record UnknownRecord65301;
    begin
        if DocTypw=Doctypw::POSOerder then begin
        Clear(OrderProfInVNo);
        FOODOrderBatchLines.Reset;
        FOODOrderBatchLines.SetCurrentkey("Unique Serial");
        if FOODOrderBatchLines.Find('+') then
          OrderProfInVNo:=FOODOrderBatchLines."Unique Serial"+1
        else OrderProfInVNo:=1;
        end else begin
          end;
    end;


    procedure Post_POS_Orders(unique_Id: Integer;ItemNo: Code[20];_Quantity: Decimal;WaiterNo: Code[20];TableId: Code[20];SalesSection: Integer;IsResidential: Boolean;GuestId: Code[20];AdditionalNotes: Text[100])
    var
        FOODOrderBatchLines: Record UnknownRecord65301;
        FOODOrderCustProdSource: Record UnknownRecord65302;
        FoodHotelShifts: Record UnknownRecord65332;
        FOODOrderBatches: Record UnknownRecord65300;
        CurrTime: Time;
        TimeFound: Boolean;
    begin
        Clear(CurrTime);
        CurrTime:=Time;
        FOODOrderBatchLines.Reset;
        FOODOrderBatchLines.SetRange("Unique Serial",unique_Id);
        if not FOODOrderBatchLines.Find('-') then begin
        //Create header Here
        FoodHotelShifts.Reset;
        // // // FoodHotelShifts.SETFILTER("Shift Start",'%1..',TIME);
        // // // FoodHotelShifts.SETFILTER("Shift End",'..%1',TIME);
        Clear(TimeFound);
        if FoodHotelShifts.Find('-') then begin
          repeat
            begin
             if CurrTime in [FoodHotelShifts."Shift Start"..FoodHotelShifts."Shift End"] then TimeFound:=true;
            end
              until ((FoodHotelShifts.Next=0) or (TimeFound=true))
        end else Error('No shifts defined');
        if TimeFound=false then Error('No shifts defined');

        FOODOrderBatches.Reset;
        FOODOrderBatches.SetRange("Batch Date",Today);
        FOODOrderBatches.SetRange("Shift Code",FoodHotelShifts.Code);
        if not FOODOrderBatches.Find('-') then begin
          FOODOrderBatches.Init;
          FOODOrderBatches.Validate("Batch Date",Today);
          FOODOrderBatches.Validate("Shift Code",FoodHotelShifts.Code);
          FOODOrderBatches.Insert(true);
          end;

        FOODOrderBatchLines.Init;
        FOODOrderBatchLines."Batch Date":=Today;
        FOODOrderBatchLines.Validate("Waiter/Waitress No.",WaiterNo);
        FOODOrderBatchLines.Validate("Table No.",TableId);
        FOODOrderBatchLines.Validate("Unique Serial",unique_Id);
        FOODOrderBatchLines.Validate("Shift Code",FoodHotelShifts.Code);
        FOODOrderBatchLines.Validate("Waiter/Waitress Section",SalesSection);
        //FOODOrderBatchLines.VALIDATE(Section,FOODOrderBatchLines."Waiter/Waitress Section");
        FOODOrderBatchLines.Validate("Is Residential",IsResidential);
        FOODOrderBatchLines.Validate("Guest ID",GuestId);
        FOODOrderBatchLines.Validate("Additional Notes",AdditionalNotes);
        FOODOrderBatchLines.Validate("Additional Comments",AdditionalNotes);
        FOODOrderBatchLines.Insert(true);
        //Validate Values and Modify
        end;
        FOODOrderCustProdSource.Reset;
        FOODOrderCustProdSource.SetRange("Batch Date",Today);
        FOODOrderCustProdSource.SetRange("Waiter/Waitress No.",WaiterNo);
        FOODOrderCustProdSource.SetRange("Item No.",ItemNo);
        FOODOrderCustProdSource.SetRange("Table No.",FOODOrderBatchLines."Table No.");
        FOODOrderCustProdSource.SetRange("Order Sequence",FOODOrderBatchLines."Order Sequence");
        FOODOrderCustProdSource.SetRange("Shift Code",FOODOrderBatchLines."Shift Code");
        if not FOODOrderCustProdSource.Find('-') then begin
        FOODOrderCustProdSource.Init;
        FOODOrderCustProdSource.Validate("Batch Date",Today);
        FOODOrderCustProdSource.Validate("Waiter/Waitress No.",WaiterNo);
        FOODOrderCustProdSource.Validate("Item No.",ItemNo);
        FOODOrderCustProdSource.Validate("Table No.",FOODOrderBatchLines."Table No.");
        FOODOrderCustProdSource.Validate("Order Sequence",FOODOrderBatchLines."Order Sequence");
        FOODOrderCustProdSource.Validate("Shift Code",FOODOrderBatchLines."Shift Code");
        FOODOrderCustProdSource.Validate("Unique Serial",FOODOrderBatchLines."Unique Serial");
        FOODOrderCustProdSource.Insert(true);
        //Validate Some Extra Fields
        FOODOrderCustProdSource.Validate(Quantity,_Quantity);
        FOODOrderCustProdSource.Modify;
        end;
    end;
}

