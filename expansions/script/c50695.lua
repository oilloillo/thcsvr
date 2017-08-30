 
--球磨型重雷装巡洋舰-北上改二
function c50695.initial_effect(c)
	c:EnableReviveLimit()
	local temp = 0
	while temp<11 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c50695.spcon)
	e2:SetOperation(c50695.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50695,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c50695.eqtg)
	e3:SetOperation(c50695.eqop)
	c:RegisterEffect(e3)
	--cannot special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e5)
end
function c50695.rfilter(c)
	return c:IsCode(50053) and c:GetFlagEffect(500530)>0
end
function c50695.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c50695.rfilter,1,nil)
end
function c50695.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c50695.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c50695.filter(c)
	return c:IsType(TYPE_EQUIP) and c:IsCode(50858)
end
function c50695.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c50695.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c50695.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c50695.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
