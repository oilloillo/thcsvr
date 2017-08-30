 
--魔女们的舞踏会
function c10018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10018,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10018.condition)
	e2:SetTarget(c10018.target)
	e2:SetOperation(c10018.operation)
	c:RegisterEffect(e2)
end
function c10018.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c10018.filter(c,e)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelBelow(5) and c:IsSetCard(0x208) and c:IsSummonable(true,e)
end
function c10018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10018.filter,tp,LOCATION_HAND,0,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10018.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10018.filter,tp,LOCATION_HAND,0,1,1,nil,e)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(10018,1))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetReset(RESET_EVENT+RESET_TOFIELD)
	e1:SetCondition(c10018.ntcon)
	tc:RegisterEffect(e1)
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c10018.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>1
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
