 
--魔界创世神 神绮
function c15019.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15019,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c15019.spcon)
	e2:SetOperation(c15019.spop)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	e4:SetCondition(c15019.condition)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	e5:SetCondition(c15019.condition)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetDescription(aux.Stringid(15019,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c15019.cost)
	e6:SetTarget(c15019.target)
	e6:SetOperation(c15019.operation)
	c:RegisterEffect(e6)
	--cannot set
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_MSET)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,1)
	e7:SetTarget(aux.TRUE)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e9)
	local e10=e7:Clone()
	e10:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e10:SetTarget(c15019.sumlimit)
	c:RegisterEffect(e10)
end
function c15019.spfilter(c)
	return c:IsSetCard(0x150) and c:IsType(TYPE_MONSTER)
end
function c15019.spfilter1(c)
	return c:IsSetCard(0x150) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c15019.spcon(e,c)
	if c==nil then return true end
	local m=Duel.GetMatchingGroupCount(c15019.spfilter1,c:GetControler(),LOCATION_HAND,0,nil)
	if m > 3 then m = 3 end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>m-3
		and Duel.CheckReleaseGroupEx(c:GetControler(),c15019.spfilter,3,e:GetHandler())
end
function c15019.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local m=Duel.GetMatchingGroupCount(c15019.spfilter1,c:GetControler(),LOCATION_HAND,0,nil)
	if m > 3 then m = 3 end
		if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
		local g1=Duel.SelectReleaseGroup(c:GetControler(),c15019.spfilter,1,3,e:GetHandler())
		Duel.Release(g1,REASON_COST)
		gc=g1:GetCount()
		local g2=Duel.SelectReleaseGroupEx(c:GetControler(),c15019.spfilter,3-gc,3-gc,e:GetHandler())
		Duel.Release(g2,REASON_COST)
	else
		local g=Duel.SelectReleaseGroupEx(c:GetControler(),c15019.spfilter,3,3,e:GetHandler())
		Duel.Release(g,REASON_COST)
	end
end
function c15019.condition(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c15019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fa=Duel.GetFlagEffect(tp,15000)
	local fb=Duel.GetFlagEffect(tp,150000)
	local fc=fa-fb
	if chk==0 then return fc<3 end
	Duel.RegisterFlagEffect(tp,15000,RESET_PHASE+PHASE_END,0,1)
end
function c15019.filter(c,e,tp)
	return c:IsSetCard(0x150) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c15019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c15019.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c15019.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c15019.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c15019.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
