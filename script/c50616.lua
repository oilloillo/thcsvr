 
--翔鹤型正规航空母舰-瑞鹤改
function c50616.initial_effect(c)
	c:EnableReviveLimit()
	local temp = 0
	while temp<9 do
		c:RegisterFlagEffect(50900,0,0,0)
		temp = temp+1
	end
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50616,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetTarget(c50616.thtg)
	e2:SetOperation(c50616.thop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50616,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c50616.eqtg)
	e3:SetOperation(c50616.eqop)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e4)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c50616.spcon)
	e6:SetOperation(c50616.spop)
	c:RegisterEffect(e6)
	--def atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DEFENCE_ATTACK)
	c:RegisterEffect(e5)
end
function c50616.tfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c50616.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c50616.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50616.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c50616.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c50616.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c50616.filter(c)
	return c:IsType(TYPE_EQUIP) and c:IsCode(50818)
end
function c50616.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c50616.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c50616.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c50616.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c50616.rfilter(c)
	return c:IsCode(50256)
end
function c50616.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c50616.rfilter,1,nil)
end
function c50616.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c50616.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
