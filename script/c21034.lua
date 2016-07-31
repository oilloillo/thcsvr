 
--地上与月面的通路
function c21034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21034,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c21034.target)
	e2:SetOperation(c21034.operation)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c21034.filter(c,e)
	return c:IsSetCard(0x256) and c:IsSummonable(true,e)
end
function c21034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21034.filter,tp,LOCATION_HAND,0,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c21034.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c21034.filter,tp,LOCATION_HAND,0,1,1,nil,e)
	local tc=g:GetFirst()
	local se=e:GetLabelObject()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(21034,1))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetReset(RESET_EVENT+RESET_TOFIELD)
	e1:SetCondition(c21034.ntcon)
	if tc then
		tc:RegisterEffect(e1)
		Duel.Summon(tp,tc,true,se)
	end
end
function c21034.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

