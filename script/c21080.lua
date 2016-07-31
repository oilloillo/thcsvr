 
--蓬莱-竹取飞翔✿蓬莱山辉夜
function c21080.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon 
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_HAND)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetCondition(c21080.hspcon)
	e0:SetOperation(c21080.hspop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e1)
	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCost(c21080.cost)
	e3:SetTarget(c21080.target)
	e3:SetOperation(c21080.recop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c21080.spr)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21080,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCondition(c21080.spcon)
	e5:SetTarget(c21080.sptg)
	e5:SetOperation(c21080.spop)
	c:RegisterEffect(e5)
end
function c21080.mtfilter(c)
	return c:GetLevel()>0 and c:IsReleasable() and c:IsSetCard(0x256)
end
function c21080.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21080.mtfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99,nil)
end
function c21080.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c21080.mtfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	local mat=mg:SelectWithSumEqual(c:GetControler(),Card.GetLevel,c:GetLevel(),1,99,nil)
	c:SetMaterial(mat)
	Duel.ReleaseRitualMaterial(mat)
	c:CompleteProcedure()
end
function c21080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21080)==0 end
	Duel.RegisterFlagEffect(tp,21080,RESET_PHASE+PHASE_END,0,1)
end
function c21080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c21080.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
function c21080.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPreviousLocation(LOCATION_MZONE) then return end
	c:RegisterFlagEffect(21080,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
end
function c21080.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount() and c:GetFlagEffect(21080)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21080.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21080.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	    Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
