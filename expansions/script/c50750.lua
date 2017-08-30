 
--晓型驱逐舰-Верный
function c50750.initial_effect(c)
	c:EnableReviveLimit()
	local temp = 0
	while temp<7 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c50750.spcon)
	e2:SetOperation(c50750.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50750,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c50750.tg)
	e3:SetOperation(c50750.op)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50750,1))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c50750.descondition)
	e4:SetTarget(c50750.destarget)
	e4:SetOperation(c50750.desoperation)
	c:RegisterEffect(e4)
	--cannot special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e5)
end
function c50750.rfilter(c)
	return c:IsCode(50192) and c:GetFlagEffect(501920)>1
end
function c50750.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c50750.rfilter,1,nil)
end
function c50750.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c50750.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c50750.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c50750.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
	end
end
function c50750.descondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c50750.destarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		return (h1<4 and Duel.IsPlayerCanDraw(tp,4-h1)) or h2>4
	end
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4-h1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,h2-4)
end
function c50750.desoperation(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if h1<4 then
		Duel.Draw(tp,4-h1,REASON_EFFECT)
	end
	if h2>4 then
		local sg=g:RandomSelect(1-tp,h2-4,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end
