 
--不死「徐福时空」
function c21123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c21123.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21123,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c21123.target)
	e2:SetOperation(c21123.operation)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21123,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c21123.revcon)
	e3:SetTarget(c21123.revtg)
	e3:SetOperation(c21123.revop)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
function c21123.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabel(0)
end
function c21123.tgfilter(c)
	return c:IsSetCard(0x161) and c:IsAbleToGrave()
end
function c21123.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21123.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c21123.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21123.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		if ct>0 then e:GetLabelObject():SetLabel(e:GetLabelObject():GetLabel()+1) end
	end
end
function c21123.revcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT)
		and	c:GetPreviousControler()==tp
end
function c21123.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local rev=e:GetLabelObject():GetLabel()*1000
	Duel.SetTargetParam(rev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rev)
end
function c21123.revop(e,tp,eg,ep,ev,re,r,rp)
	local rev=e:GetLabelObject():GetLabel()*1000
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rev,REASON_EFFECT)
end
