--永远与须臾的月兔✿蓬莱山辉夜
function c19033.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x255),aux.FilterBoolFunction(Card.IsFusionSetCard,0x261),true)
	--spell set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19033,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c19033.stg)
	e1:SetOperation(c19033.sop)
	c:RegisterEffect(e1)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c19033.spr)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(19033,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCondition(c19033.spcon)
	e5:SetTarget(c19033.sptg)
	e5:SetOperation(c19033.spop)
	c:RegisterEffect(e5)
end
c19033.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0x255),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x261),
}
function c19033.filter(c)
	return c:IsSetCard(0x256) and c:IsAbleToHand()
end
function c19033.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c19033.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19033.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c19033.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c19033.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local def=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND):GetFirst():GetDefense()
		Duel.Recover(tp,def,REASON_EFFECT)
    end
end
function c19033.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)==0 or bit.band(r,REASON_DESTROY)==0 or not c:IsPreviousLocation(LOCATION_ONFIELD) then return end
	c:RegisterFlagEffect(19033,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_STANDBY,0,2)
end
function c19033.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount() and c:GetFlagEffect(19033)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c19033.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
